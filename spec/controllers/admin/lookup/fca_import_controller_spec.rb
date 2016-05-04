RSpec.describe Admin::Lookup::FcaImportController, type: :controller do
  let(:email) { 'bob@example.com' }

  describe '#new' do
    it 'renders the new view' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe '#upload_firms' do
    it 'unzips uploaded file and passes on the contents of firms file' do
      upload_double = class_double('UploadFcaDataJob').as_stubbed_const
      expect(upload_double).to receive(:perform_later).with("firm file contents\n", email, 'date_a.zip')

      post :upload_firms, zip_file: fixture_file_upload('spec/fixtures/date_a.zip'), email: email
    end
  end

  describe '#upload_subsidiaries' do
    it 'unzips uploaded file and passes on the contents of subsidiaries file' do
      upload_double = class_double('UploadFcaDataJob').as_stubbed_const
      expect(upload_double).to receive(:perform_later).with("Subsidiary file contents\n", email, 'date_c.zip')

      post :upload_subsidiaries, zip_file: fixture_file_upload('spec/fixtures/date_c.zip'), email: email
    end
  end

  describe '#upload_advisers' do
    it 'unzips uploaded file and passes on the contents of subsidiaries file' do
      upload_double = class_double('UploadFcaDataJob').as_stubbed_const
      expect(upload_double).to receive(:perform_later).with("Adviser file contents\n", email, 'date_f.zip')

      post :upload_advisers, zip_file: fixture_file_upload('spec/fixtures/date_f.zip'), email: email
    end
  end

  describe '#upload_status' do
    it 'renders the upload_status view' do
      get :upload_status
      expect(response).to render_template(:upload_status)
    end
  end

  describe '#import' do
    context 'imports firms' do
      it 'empties lookup_firms' do
        Lookup::Firm.create fca_number: 123456, registered_name: 'to be deleted'
        post :import
        expect(Lookup::Firm.count).to eql(0)
      end

      it 'copies contents over from lookup_import_firms' do
        Lookup::Import::Firm.create fca_number: 111111, registered_name: 'first to be imported'
        Lookup::Import::Firm.create fca_number: 222222, registered_name: 'second to be imported'

        post :import

        expect(Lookup::Firm.find_by(fca_number: 111111)).to be_present
        expect(Lookup::Firm.find_by(fca_number: 222222)).to be_present
      end
    end

    context 'imports subsidiaries' do
      it 'empties lookup_subsidiaries' do
        Lookup::Subsidiary.create fca_number: 123456, name: 'to be deleted'
        post :import
        expect(Lookup::Subsidiary.count).to eql(0)
      end

      it 'copies contents over from lookup_import_subsidiaries' do
        Lookup::Import::Subsidiary.create fca_number: 111111, name: 'first to be imported'
        Lookup::Import::Subsidiary.create fca_number: 222222, name: 'second to be imported'

        post :import

        expect(Lookup::Subsidiary.find_by(fca_number: 111111)).to be_present
        expect(Lookup::Subsidiary.find_by(fca_number: 222222)).to be_present
      end
    end

    context 'imports advisers' do
      it 'empties lookup_advisers' do
        Lookup::Adviser.create reference_number: 'ABC12345', name: 'to be deleted'
        post :import
        expect(Lookup::Adviser.count).to eql(0)
      end

      it 'copies contents over from lookup_import_advisers' do
        Lookup::Import::Adviser.create reference_number: 'ABC11111', name: 'first to be imported'
        Lookup::Import::Adviser.create reference_number: 'ABC22222', name: 'second to be imported'

        post :import

        expect(Lookup::Adviser.find_by(reference_number: 'ABC11111')).to be_present
        expect(Lookup::Adviser.find_by(reference_number: 'ABC22222')).to be_present
      end
    end
  end
end
