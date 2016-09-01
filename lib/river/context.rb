module River
  class Context < Hash
    attr_writer :writer

    def write(data)
      @writer.write(data)
    end
  end
end
