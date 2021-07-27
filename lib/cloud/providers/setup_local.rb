# Not a part of the system's functionality, just a developer utilty - written in a rush
#
# Creates symbolic links in local dir (tmp/azure/) that point to a set of zip files
# in another dir (source_dir).
#
# Was written because the tests delete the files in tmp/azure/
#
# Use from console, for instance:
#   $ rails runner "Cloud::Providers::SetupLocal.new('../../../a_zip_files_dir', date: '20210708', letters: %w[b c d f h i j]).()" 2>/dev/null | sh
#
module Cloud
  module Providers
    class SetupLocal
      # rubocop:disable all
=begin
      PATH = 'tmp/azure'.freeze

      DOWNLOADS = '~/Downloads'

      OUT_FILE_PREFIX = 'Incoming\\\\'

      attr_accessor :source_path, :date, :letters

      def initialize(source_path = DOWNLOADS, date: '20210513', letters: %w[c f l])
        self.source_path = source_path

        self.date = date

        self.letters = letters
      end

      def call
        mkdir

        puts links * "\n"
      end

      def rm
        "rm -rf #{path}/Incoming*"
      end

      private

      def mkdir
        unless Dir.exist? PATH
          Dir.mkdir PATH

          $stderr.puts "Created dir #{PATH}"
        end
      end

      def links
        letters.map {|letter| link(letter) }
      end
      def link(letter)
        "ln -s #{source letter} #{target letter}"
      end

      def source(letter)
        path = source_path.presence || ''

        File.join path, zip_file(letter)
      end

      def target(letter)
        file = OUT_FILE_PREFIX + zip_file(letter)

        path file #, root: ''
      end

      def zip_file(letter)
        "#{date}#{letter}.zip"
      end

      def path(file_name=nil, root: nil, subdir: PATH)
        root = root.presence || Rails.root

        File.join(root, subdir || '', file_name || '')
      end
=end
      # rubocop:enable all
    end
  end
end
