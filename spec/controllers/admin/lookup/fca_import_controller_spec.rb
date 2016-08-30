RSpec.describe Admin::Lookup::FcaImportController, type: :controller do
  let(:files) { %w(20160825a.zip 20160825b.zip 20160825c.zip) }

  before do
    allow_any_instance_of(Cloud::Storage)
      .to receive(:list).and_return(files)
  end

  describe '#index' do
    before { get :index }

    it 'renders import page' do
      expect(response).to be_success
    end

    it 'assigns a list files available for import' do
      expect(assigns[:files]).to eq(files)
    end
  end

  describe '#create' do
    it 'creates a `fca import job`' do
      expect(FcaImportJob).to receive(:perform_async).with(files)
      post :create, files: files
    end
  end
end
