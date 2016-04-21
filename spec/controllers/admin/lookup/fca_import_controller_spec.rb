RSpec.describe Admin::Lookup::FcaImportController, type: :controller do
  describe '#new' do
    it 'renders the new view' do
      get :new
      expect(response).to render_template(:new)
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
