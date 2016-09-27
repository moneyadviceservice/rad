require 'logger'
require 'forwardable'

module FCA
  class Config
    class << self
      extend Forwardable

      def_delegators :config, :logger, :notify, :hostname

      def configure
        yield config if block_given?
      end

      def config
        @config ||= FCA::Config.new
      end
    end

    LOG_LEVEL = %w(UNKNOWN FATAL ERROR WARN INFO DEBUG).freeze

    attr_accessor :notify, :hostname
    attr_writer :log_file, :log_level

    def logger
      @logger ||= ::Logger.new(log_file, ::File::APPEND)
      @logger.level = log_level
      @logger
    end

    def log_file
      @log_file = STDOUT if @log_file.nil?
      @log_file
    end

    def log_level
      level = LOG_LEVEL.detect { |level| level == @log_level.to_s.upcase.strip } || 'INFO'
      Object.const_get("Logger::#{level}")
    end
  end
end
