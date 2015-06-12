module Dashboard
  RSpec.describe Dashboard::AdvisersController, type: :controller do
    include_context 'advisers controller'

    describe '#new' do
      before { get :new, firm_id: firm.id }

      it 'provides the firm to the view' do
        expect(assigns(:firm)).to eq firm
      end

      it 'provides a newly built adviser to the view' do
        expect(assigns(:adviser)).to be_a Adviser
        expect(assigns(:adviser)).to_not be_persisted
      end

      it 'assigns the newly built adviser to the firm' do
        expect(assigns(:adviser).firm).to eq firm
      end
    end
  end
end
