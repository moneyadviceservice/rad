module River
  class Outcome < Hash
    attr_reader :result
    def initialize(&blk)
      @result = run(blk)
    end

    def success?
      !@result.class.ancestors.include?(Exception)
    end

    def to_s
      self[:success] = success?
      super
    end

    private

    def run(blk)
      blk.call
    rescue Exception => e # rubocop:disable all
      e
    end
  end
end
