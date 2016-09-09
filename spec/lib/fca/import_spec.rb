require 'stringio'

RSpec.describe FCA::Import do
  before(:all) { Cloud::Storage.setup }
  after(:all)  { Cloud::Storage.teardown }

  let(:files)  { %w(a b c d).map { |e| "20160830#{e}.zip" } }
  let(:upload_files) { files.each { |f| Cloud::Storage.upload(f) } }

  describe 'FCA::Import.call' do
    it 'invokes `import` method with specific args' do
      expect(FCA::Import)
        .to receive(:import)
        .with(files, ActiveRecord::Base.connection, 'FCA::Import', FCA::Config.logger)
      FCA::Import.call(files)
    end
  end

  describe 'FCA::Import.import' do
    let(:log_file) { StringIO.new }
    let(:logger)   { Logger.new(log_file) }
    let(:db_conn)  { spy('db connection') }

    let(:callback) { :callback_done }
    let(:import)   { FCA::Import.import(files, db_conn, 'test', logger) }
    let(:import_with_callback) { FCA::Import.import(files, db_conn, 'test', logger) { callback } }

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

    it 'runs generated sql' do
      import
      expect(db_conn).to have_received(:execute).at_least(:once)
    end

    context 'when an error occurs' do
      let(:outcome) { double('outcome', success?: false) }
      before { allow_any_instance_of(River::Core).to receive(:sink).and_return(outcome) }

      it 'returns an empty array' do
        expect(import).to be_empty
      end
    end

    context 'when successful' do
      let(:outcome) { double('outcome', success?: true) }
      before { allow_any_instance_of(River::Core).to receive(:sink).and_return(outcome) }

      it 'returns a array with diff for advisers, firms and subsidiaries' do
        import.each do |diff|
          expect(diff).to be_a(Hash)
          expect(diff.keys).to match_array([:added, :updated, :deleted])
        end
      end
    end
  end
end
