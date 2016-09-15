require 'forwardable'

module Cloud
  class Storage
    extend Forwardable
    def_delegators :provider, :list, :download, :move, :upload, :setup, :teardown
    attr_reader :provider

    def initialize(provider_name, settings = {})
      @provider = find_provider_class(provider_name).new(settings)
    end

    class << self
      extend Forwardable

      def_delegators :client, :list, :download, :move, :upload, :setup, :teardown

      def configure
        yield config if block_given?
      end

      def config
        @config ||= Cloud::Config.new
      end

      def client
        @client ||= new(config.provider_name, config.settings)
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
