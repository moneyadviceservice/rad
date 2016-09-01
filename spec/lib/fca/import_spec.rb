require 'stringio'

RSpec.describe FCA::Import do
  describe 'FCA::Import.call' do
    let(:log_file) { StringIO.new }
    let(:logger)   { Logger.new(log_file) }
    let(:files)    { %w(a b c d).map { |e| "20160830#{e}.zip" } }

    let(:callback) { :callback_done }
    let(:import)   { FCA::Import.call(files, logger) }
    let(:import_with_callback) { FCA::Import.call(files, logger) { callback } }

    it 'logs progression' do
      import
      expect(log_file.string).to include 'Starting FCA data import'
      expect(log_file.string).to include 'Duration'
      expect(log_file.string).not_to include 'Running callback'
    end

    it 'executes block when given' do
      import_with_callback
      expect(log_file.string).to include 'Running callback'
      expect(log_file.string).to include "Callback outcome: #{callback}"
    end
  end
end
