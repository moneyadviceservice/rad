require 'logger'
require_relative 'runners'

module River
  class Core
    attr_reader :context, :commands
    def initialize(context = {})
      @context = context
      @context[:logger] ||= Logger.new(nil)
      @commands = []
    end

    def step(&blk)
      @commands << blk
      self
    end

    def sink(runner = :tempfile)
      msg = "Could not find runner: `#{runner}` in #{Runners.all}"
      (Runners.fetch(runner) { log_and_fail(msg) }).call(commands.dup, context)
    end

    private

    def log_and_fail(s)
      context[:logger].fatal('River') { s }
      fail s
    end
  end
end
