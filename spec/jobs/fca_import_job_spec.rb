RSpec.describe FcaImportJob do
  let(:files) { %w(advisers.zip) }
  let(:db)    { spy('db connection') }
  let(:slack) { spy('slack') }
  let(:outcomes) { [['adviers.zip', true, [:download, :unzip, :to_sql, :save]]] }
  let(:model)  { FactoryGirl.create(:import) }
  let(:model_dup)  { FactoryGirl.build(:import) }
  let(:format) do
    { channel: '#test-channel', as_user: true, text: '' }
  end

  before(:all) do
    Cloud::Storage.setup
    %w(advisers.zip).each { |e| Cloud::Storage.upload(e, fixture(e).read) }
  end

  after(:all) { Cloud::Storage.teardown }

  before do
    allow_any_instance_of(FcaImportJob).to receive(:db_connection).and_return(db)
    allow_any_instance_of(FcaImportJob).to receive(:slack).and_return(slack)
    allow(FCA::Config).to receive(:logger).and_return(spy('logger'))
  end

  describe '.perform' do
    it 'creates a fca_import' do
      expect(FcaImport)
        .to receive(:create)
        .with(files: files.join('|'), status: 'processing')
        .and_return(model)
      suppress_output { subject.perform(files) }
    end

    it 'stops the execution' do
      expect(FcaImport)
        .to receive(:create)
        .with(files: files.join('|'), status: 'processing')
        .and_return(model_dup)

      expect(FCA::Import).not_to receive(:call)
      suppress_output { subject.perform(files) }
    end

    it 'invokes fac import lib' do
      expect(FCA::Import).to receive(:call).with(files, kind_of(Hash))
      suppress_output { subject.perform(files) }
    end

    context 'when import successful' do
      let(:expected) do
        format.merge(text: '<!here> The FCA data have been loaded into RAD. Visit http://localhost/admin/lookup/fca_import to confirm that the data looks ok') # rubocop:disable all
      end

      it 'callback has access to import outcome' do
        suppress_output { subject.perform(files) }
        expect(slack).to have_received(:chat_postMessage).with(expected)
      end
    end

    context 'when an unzip has occured' do
      let(:expected) do
        format.merge(text: "<!here> Import has failed\nZip file badfile.zip caused error: could not be unzipped. The file could be corrupted.\nYou can cancel this import here http://localhost/admin/lookup/fca_import") # rubocop:disable all
      end

      it 'callback has access to import outcome' do
        suppress_output { subject.perform(%w(badfile.zip)) }
        expect(slack).to have_received(:chat_postMessage).with(expected)
      end
    end
  end
end
