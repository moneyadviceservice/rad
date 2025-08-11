require 'cloud'
require 'zip'

module FCA
  module Utils
    def download(filename)
      lambda do |_, w, c|
        client = Cloud::Storage.client
        client.download(filename).each(&write_line(w))
        c[:logger].info('Azure') { "Downloaded file '#{filename}'" }
        :download
      end
    end

    def unzip(regexps)
      ignore_file = ->(s) { (regexps.map { |r| s =~ r }).any? }

      lambda do |r, w, c|
        Zip::File.foreach(r) do |entry|
          c[:logger].info('UNZIP') { "Found file `#{entry.name}`" }
          if ignore_file[entry.name]
            c[:logger].info('UNZIP') { "Extracting file `#{entry.name}`" }
            c[:filenames] ||= []
            c[:filenames] << entry.name

            # Read the contents of the zip file entry as binary
            entry.get_input_stream.each do |line|
              # Expect contents to be ISO-8859-1 encoded, and convert them to UTF-8
              line.force_encoding(Encoding::ISO8859_1).encode!(Encoding::UTF_8)
              w.write(line)
            end
          else
            c[:logger].info('UNZIP') { "Ignoring file `#{entry.name}`" }
            next
          end
        end
        :unzip
      end
    end

    def to_sql(table_prefix = '', name = 'ToSql')
      lambda do |r, w, _|
        q = nil
        r.each do |line|
          row = Row.new(line, delimeter: '|', prefix: table_prefix)
          if row.header?
            logger.debug(name) { "Header line detected for: '#{row.line}'" }
            q = row.query { |a| log_and_fail("Cannot find table for header line: '#{row.line}' in #{a}") }
            write(w, q.begin)                { 'Added begin' }
            write(w, q.create_if_not_exists) { 'Added create' }
            write(w, q.truncate)             { 'Added truncate' }
            write(w, q.copy_statement)       { 'Added copy' }
          else
            if row.footer? && !row.header?
              write(w, q.commit) { 'Added commit' }
            else
              log_and_fail('Have some data but no query to format it.') unless q
              write(w, q.values(row))
            end
          end
        end
        :to_sql
      end
    end

    def dump
      lambda do |r, w, c|
        name = c[:filenames].last.split('.').first
        ::File.open(::File.join(Rails.root, 'tmp', "#{name}-dump.sql"), 'a') do |f|
          r.each { |l| f.write(l) }
          f.flush
        end
        logger.debug('Dump') { "#{name}-dump.sql" }
        r.rewind
        r.each(&write_line(w))
        :dump
      end
    end

    def save
      is_a_copy   = ->(l) { l =~ /^copy .+/i }
      is_a_values = ->(l) { l.split('|').count > 1 }
      # rubocop:disable all
      lambda do |r, _, c|
        while line = r.gets
          if is_a_copy[line]
            c[:pg].copy_data(line) do
              while values = r.gets
                if is_a_values[values]
                  c[:pg].put_copy_data(values)
                else
                  values.reverse.each_char { |c| r.ungetc(c) }
                  break
                end
              end
            end
          else
            c[:pg].exec(line)
          end
        end
        :save
      end
      # rubocop:enable all
    end

    def import_successful?(outcomes)
      outcomes.map(&:second).all?
    end

    def write_line(w)
      ->(l) { w.write(l.force_encoding('UTF-8')) }
    end

    def log_and_fail(msg)
      logger.fatal('Import Error') { msg }
      raise msg
    end

    def write(w, s)
      logger.debug { yield } if block_given?
      w.write(s)
    end
  end
end
