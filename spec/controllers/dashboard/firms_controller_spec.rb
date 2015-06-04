module Dashboard
  RSpec.describe Dashboard::FirmsController, type: :controller do
    let(:principal) { FactoryGirl.create(:principal) }
    let(:firm) do
      firm_attrs = FactoryGirl.attributes_for(:firm_with_trading_names, fca_number: principal.fca_number)
      principal.firm.update_attributes(firm_attrs)
      principal.firm
    end
    let(:user) { FactoryGirl.create :user, principal: firm.principal }
    before { sign_in(user) }

    describe 'GET index' do
      context 'when all trading names are registered' do
        it 'assigns all trading names' do
          get :index
          expect(assigns(:trading_names).count).to eq 3
        end
      end

      context 'when some trading names are registered' do
        before do
          trading_name = firm.trading_names.first
          trading_name.email_address = nil
          trading_name.save(validate: false)
        end

        it 'assigns only registered trading names' do
          get :index
          expect(assigns(:trading_names).count).to eq 2
        end
      end
    end
  end
end
