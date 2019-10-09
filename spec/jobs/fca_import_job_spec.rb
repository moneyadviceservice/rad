RSpec.describe FcaImportJob do
  let(:files) { %w[advisers.zip] }
  let(:db)    { spy('db connection') }
  let(:outcomes) { [['adviers.zip', true, %i[download unzip to_sql save]]] }
  let(:model) { FactoryBot.create(:import) }
  let(:model_dup) { FactoryBot.build(:import) }
  let(:format) do
    { channel: '#test-channel', as_user: true, text: '' }
  end

  before(:all) do
    Cloud::Storage.setup
    %w[advisers.zip].each { |e| Cloud::Storage.upload(e, fixture(e).read) }
  end

  after(:all) { Cloud::Storage.teardown }

  before do
    allow_any_instance_of(FcaImportJob).to receive(:db_connection).and_return(db)
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
  end
end
