module SelfService
  RSpec.describe SelfService::AdvisersController, type: :controller do
    include_context 'fca api ok response'
    include_context 'advisers controller'
    
    describe '#edit' do
      it 'provides the firm to the view' do
        get :edit, firm_id: firm.id, id: adviser.id
        expect(assigns(:firm)).to eq(firm)
      end

      it 'provides the adviser to the view' do
        get :edit, firm_id: firm.id, id: adviser.id
        expect(assigns(:adviser)).to eq(adviser)
      end
    end
  end
end
