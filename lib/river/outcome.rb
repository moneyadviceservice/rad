module River
  class Outcome < Hash
    def initialize(result)
      @result = result
    end

    def success?
      !@result.key?(:error)
    end
  end
end
