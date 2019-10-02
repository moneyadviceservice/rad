module SelfService
  RSpec.describe SelfService::OfficesController, type: :controller do
    include_context 'offices controller'

    describe '#new' do
      before { get :new, firm_id: firm.id }

      it 'provides the firm to the view' do
        expect(assigns(:firm)).to eq firm
      end

      it 'provides a newly built office to the view' do
        expect(assigns(:office)).to be_a Office
        expect(assigns(:office)).to_not be_persisted
      end

      it 'assigns the newly built office to the firm' do
        expect(assigns(:office).firm).to eq firm
      end
    end
  end
end
