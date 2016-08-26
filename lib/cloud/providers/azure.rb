require 'azure/storage'
require 'tempfile'

module Cloud
  module Providers
    class Azure
      attr_reader :settings

      def initialize(settings)
        @settings = settings
      end

      def list
        blob_client.list_blobs(container.name).map {|e| e.try(:name) }
      end

      def download(file_name)
        _, content = blob_client.get_blob(container.name, file_name)
        file = Tempfile.new(file_name)
        file.write(content)
        file.rewind
        file
      end

      def move(src, dst)
        blob_client.copy_blob(container.name, src, container.name, dst)
      end

      private

      def container
        @container ||= blob_client.list_containers.detect {|e| e.name == settings[:container_name] }
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
