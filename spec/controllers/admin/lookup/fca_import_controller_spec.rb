  let(:files) { %w[incoming/20160825a.zip incoming/20160825b.zip incoming/20160825c.zip] }
RSpec.describe Admin::Lookup::FcaImportController, type: :request do
  let(:last_import) { FcaImport.last }

  before(:all) { FactoryBot.create(:not_confirmed_import) }

  before do
    allow_any_instance_of(Cloud::Storage)
      .to receive(:list).and_return(files)
    allow(FcaImport).to receive(:find).and_return(last_import)
  end

  describe '.create' do
    it 'creates a `fca import job`' do
      expect(FcaImportJob).to receive(:perform_async).with(files)
      post :create, files: files
    end
  end

  describe '.update' do
    context 'when confirming' do
      it 'starts apply import changes' do
        expect(last_import).to receive(:commit).with('Confirm')
        put :update, id: last_import.id, commit: 'Confirm'
      end
    end

    context 'when cancelling' do
      it 'marks import as cancelled' do
        expect(last_import).to receive(:commit).with('Cancel')
        put :update, id: last_import.id, commit: 'Cancel'
      end
    end
  end
end
