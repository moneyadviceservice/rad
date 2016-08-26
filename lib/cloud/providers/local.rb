module Cloud
  module Providers
    class Local
      PATH = '/tmp/azure'.freeze

      attr_reader :settings
      def initialize(settings = {})
        @settings = settings
      end

      # rubocop:disable all
      def list
        %x(ls #{path('.')}).split
      end

      def download(file)
        File.open(path(file))
      end

      def upload(file)
        %x(touch #{path(file)})
      end

      def move(src, dst)
        %x(mv #{path(src)} #{path(dst)})
      end

      def setup
        %x(rm -rf #{path('')} 2>/dev/null; mkdir -p #{path('')})
      end

      def teardown
        %x(rm -rf #{path('')})
      end
      # rubocop:enable all

      private

      def path(file_name)
        root = settings[:root] || File.dirname(__FILE__)
        File.join(root, PATH, file_name)
      end
    end
  end
end
