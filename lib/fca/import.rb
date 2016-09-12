$LOAD_PATH.unshift(File.join(Rails.root, 'lib'))
require 'river'
require 'cloud'
require 'zip'
require 'pg'

module FCA
  class Import
    class << self
      def call(files, db)
        import(files, db, 'FCA::Import', FCA::Config.logger)
      end

      def import(files, db, name, logger)
        logger.info(name) { 'Starting FCA data import' }
        start_time = Time.zone.now
        outcome = new(files, db, logger).import_all
        logger.info(name) { "Duration: #{Time.zone.now - start_time} seconds" }

        if block_given?
          logger.debug(name) { 'Running callback' }
          cb_outcome = yield(outcome, logger)
          logger.info(name) { "Callback outcome: #{cb_outcome}" }
        end

        outcome
      end
    end

    attr_reader :files, :logger, :context

    def initialize(files, db, logger)
      @files   = files
      @logger  = logger
      @context = { logger: @logger, pg: db }
    end

    def import_all
      result = files.map { |file| import(file) }
      if import_successful?(result)
        logger.info('FCA import') { 'files imported successfully' }
      else
        logger.info('FCA import') { 'import failed' }
      end
      result
    end

    def import(file)
      outcomes = River.source(context)
                 .step(&download(file))
                 .step(&unzip(/^firms2\d+\.ext$/, /^indiv_apprvd2\d+\.ext$/, /^firm_names2\d+\.ext$/))
                 .step(&to_sql('fcaimport'))
                 .step(&save)
                 .sink

      import_status = outcomes.map(&:success?).all?
      if import_status
        logger.info("Import #{file}") { 'imported successfully' }
        # TODO: move files to archived
      else
        logger.info("Import #{file}") { "import error #{outcomes.last.result}" }
      end

      [file, import_status, outcomes]
    end

    private

    def download(filename)
      lambda do |_, w, c|
        client = Cloud::Storage.client
        client.download(filename).each(&write_line(w))
        c[:logger].info('Azure') { "Downloaded file '#{filename}'" }
      end
    end

    def unzip(*regexps)
      ignore_file = ->(s) { (regexps.map { |r| s =~ r }).any? }

      lambda do |r, w, c|
        r.set_encoding('ISO8859-1')
        Zip::InputStream.open(r) do |io|
          while (entry = io.get_next_entry)
            c[:logger].info('UNZIP') { "Found file `#{entry.name}`" }
            if ignore_file[entry.name]
              c[:logger].info('UNZIP') { "Extracting file `#{entry.name}`" }
              c[:filenames] ||= []
              c[:filenames] << entry.name
              io.each { |l| w.write(l.force_encoding('UTF-8')) }
            else
              c[:logger].info('UNZIP') { "Ignoring file `#{entry.name}`" }
              next
            end
          end
        end
      end
    end

    def to_sql(table_prefix = '')
      name = 'ToSql'
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
              write(w, q.commit)               { 'Added commit' }
            else
              log_and_fail('Have some data but no query to format it.') unless q
              write(w, q.values(row))
            end
          end
        end
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
      end
      # rubocop:enable all
    end

    def import_successful?(outcomes)
      outcomes.map(&:second).all?
    end

    def write_line(w)
      ->(l) { w.write(l) }
    end

    def log_and_fail(msg)
      logger.fatal(name) { msg }
      fail msg
    end

    def write(w, s)
      logger.debug { yield } if block_given?
      w.write(s)
    end
  end
end
