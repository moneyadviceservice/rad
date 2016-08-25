require 'forwardable'

module Cloud
  class Storage
    extend Forwardable

    attr_reader :provider

    def initialize(provider_name, settings={})
      @provider = find_provider_class(provider_name).new(settings)
    end

    def_delegators :provider, :list
    def_delegators :provider, :download
    def_delegators :provider, :move

    class << self
      def configure
        yield config if block_given?
      end

      def config
        @config ||= Cloud::Config.new
      end

      def init
        new(config.provider_name, config.settings)
      end
    end
    
    private

    def find_provider_class(name)
      klass = Object.const_get("::Cloud::Providers::#{name.to_s.capitalize}")
      klass
    rescue
      raise ArgumentError.new('Bad cloud provider name')
    end
  end
end
