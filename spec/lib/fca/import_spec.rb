require 'stringio'

RSpec.describe FCA::Import do
  before(:all) { Cloud::Storage.setup }
  after(:all)  { Cloud::Storage.teardown }

  let(:db)     { spy('pg_connection') }
  let(:files)  { %w(a b).map { |e| "20160830#{e}.zip" } }
  let(:upload_files) { files.each { |f| Cloud::Storage.upload(f) } }

  describe '.call' do
    let(:log_file) { StringIO.new }
    let(:logger)   { Logger.new(log_file) }

    let(:callback) { :callback_done }
    let(:import)   { FCA::Import.call(files, db, 'test', logger) }
    let(:import_with_callback) { FCA::Import.call(files, db, 'test', logger) { callback } }

    before { upload_files }

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

    context 'when an error occurs' do
      let(:outcome) { double('outcome', success?: false, result: 'result str') }
      before { allow_any_instance_of(River::Core).to receive(:sink).and_return([outcome]) }

      it 'returns an empty array' do
        expect(import[0]).to match_array ['20160830a.zip', false, [outcome]]
        expect(import[1]).to match_array ['20160830b.zip', false, [outcome]]
      end
    end

    context 'when successful' do
      let(:outcome) { double('outcome', success?: true) }
      before { allow_any_instance_of(River::Core).to receive(:sink).and_return([outcome]) }

      it 'returns a array with diff for advisers, firms and subsidiaries' do
        expect(import[0]).to match_array ['20160830a.zip', true, [outcome]]
        expect(import[1]).to match_array ['20160830b.zip', true, [outcome]]
      end
    end
  end
end
