require 'azure/storage'
require 'tempfile'
require 'stringio'

module Cloud
  module Providers
    class Azure
      attr_reader :settings

      def initialize(settings)
        @settings = settings
      end

      def list
        blob_client.list_blobs(container.name).map(&:name)
      end

      def download(file_name)
        _, content = blob_client.get_blob(container.name, file_name)
        StringIO.new(content, 'r')
      end

      def move(src, dst)
        blob_client.copy_blob(container.name, dst, container.name, src)
        blob_client.delete_blob(container.name, src)
      end

      def upload(_file, _content = nil)
        # present for provider interface consistency
        fail 'Define me!!'
      end

      def setup
        container
      end

      def teardown
        # does nothing in the case of azure
      end

      private

      def container
        @container ||= blob_client.list_containers.detect { |e| e.name == settings[:container_name] }
        rescue StandardError
          raise ::Cloud::ConfigError.new("Could not find any container named #{settings[:container_name]}")
      end

      def blob_client
        @client ||= ::Azure::Storage::Client.create(
          storage_account_name: settings[:account_name],
          storage_access_key:   settings[:shared_key]
        )
        @client.blobClient
      end
    end
  end
end
