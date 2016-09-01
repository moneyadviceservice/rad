module River
  class Core
    attr_reader :filename, :context, :reader

    def initialize(filename, client = Cloud::Storage.init)
      @filename = filename
      @context = Context.new
      @client = client
    end

    def source
      @reader = @client.download(filename)
      self
    end

    def step(&blk)
      # rubocop:disable all
      rd, wr = IO.pipe
      context.writer = wr
      while line = reader.gets
        blk.call(line, context)
      end
      wr.close
      reader.close
      @reader = rd
      # rubocop:enable all
      self
    end

    def sink(&blk)
      # expect block to return an instanciated db object
      # the db object must respond to :execute
      conn = blk.call(context)
      res = conn.execute(reader.read)
      reader.close
      Outcome.new(res)
    end
  end
end
