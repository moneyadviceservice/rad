module River
  class Outcome < Hash
    attr_reader :result

    def initialize(result)
      @result = result
    end

    def success?
      return false if [Exception, Sidekiq::Shutdown].include?(@result.class)
      true
    end
  end
end
