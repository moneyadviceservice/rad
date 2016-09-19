RSpec.describe FcaImportJob do
  let(:files) { %w(advisers.zip) }
  let(:db)    { spy('db connection') }
  let(:slack) { spy('slack') }
  let(:outcomes) { [['adviers.zip', true, [:download, :unzip, :to_sql, :save]]] }
  let(:format) do
    { as_user: true, channel: '#test-channel', text: '' }
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
    it 'invokes fac import lib' do
      expect(FCA::Import).to receive(:call).with(files, db)
      subject.perform(files)
    end

    context 'when import successful' do
      let(:expected) do
        format.merge(text: 'The FCA data have been loaded into RAD. \
Visit http://localhost/admin/lookup/fca_import to confirm that the data looks ok')
      end

      it 'callback has access to import outcome' do
        subject.perform(files)
        expect(slack).to have_received(:chat_postMessage).with(expected)
      end
    end

    context 'when an error has occured' do
      let(:expected) do
        format.merge(text: 'An error has occured while processing the files')
      end

      it 'callback has access to import outcome' do
        subject.perform(%w(badfile.zip))
        expect(slack).to have_received(:chat_postMessage).with(expected)
      end
    end
  end
end
