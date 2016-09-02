require_relative 'outcome'
require 'pg'

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
              STDOUT.write("PG: ->>>>>>> #{line}")
              conn.put_copy_data(line)
            end
          end
          rescue Exception => e
            STDOUT.write("ERROR: #{e.to_s}\n")
            STDERR.write("ERROR: #{e.to_s}\n")
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
      line.split('|').split('|').count > 1
    end
  end
end
