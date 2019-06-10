module SelfService
  RSpec.describe SelfService::OfficesController, type: :controller do
    include_context 'fca api ok response'
    include_context 'offices controller'

    describe '#edit' do
      before do
        get :edit, firm_id: firm.id, id: office.id
      end

      it 'provides the firm to the view' do
        expect(assigns(:firm)).to eq(firm)
      end

      it 'provides the office to the view' do
        expect(assigns(:office)).to eq(office)
      end
    end
  end
end
