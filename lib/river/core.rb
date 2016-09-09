require_relative 'outcome'
require_relative 'context'
require 'pg'

$:.unshift(File.join(Rails.root, 'lib'))
require 'cloud'

module River
  class Core
    attr_reader :filename, :context, :reader, :error

    def initialize(filename, client = Cloud::Storage.client)
      @filename = filename
      @context = Context.new
      @client = client
    end

    def source
      @reader = @client.download(filename)
      self
    end

    def step(&blk)
      rd, wr = IO.pipe
      context.writer = wr
      begin
        blk.call(reader, context)
      rescue Exception => e
        @error = e
      end
      wr.close
      reader.close
      @reader = rd
      self
    end

    def sink(&blk)
      return Outcome.new(error) if error
      begin
        conf = blk.call(context)
        conn = PG::Connection.new(conf)

        line = reader.gets
        if copy_statement?(line)
          begin
          res = conn.copy_data(line) do
            while line = reader.gets
              break if !data_statement?(line)
              begin
                STDOUT.write("adding data line #{line}\n")
                conn.put_copy_data(line)
              rescue Exception => e
                STDOUT.write("put_copy_data ERROR: #{e.to_s}\n")
                STDERR.write("put_copy_data ERROR: #{e.to_s}\n")
              end
            end
          end
          rescue Exception => e
            STDOUT.write("copy_data ERROR: #{e.to_s}\n")
            STDERR.write("copy_data ERROR: #{e.to_s}\n")
          end
        end

        reader.close
        Outcome.new(res)
      rescue Exception => e
        @error = e
        Outcome.new(error)
      end
    end

    private

    def copy_statement?(line)
      !!(line && line =~ /^copy .+/i)
    end

    def data_statement?(line)
      line.split('|').count > 1
    end
  end
end
