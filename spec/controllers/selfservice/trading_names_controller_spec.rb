module SelfService
  RSpec.describe SelfService::TradingNamesController, type: :controller do
    let(:principal) { FactoryGirl.create(:principal) }
    let(:firm) do
      firm_attrs = FactoryGirl.attributes_for(:firm, fca_number: principal.fca_number)
      principal.firm.update_attributes(firm_attrs)
      principal.firm
    end
    let(:user) { FactoryGirl.create :user, principal: firm.principal }
    let(:lookup_subsidiary) { FactoryGirl.create(:lookup_subsidiary, fca_number: principal.fca_number) }
    before { sign_in(user) }

    def build_firm_params(params = {})
      firm = FactoryGirl.build(:firm)
      firm_params = firm.attributes
      firm_params.symbolize_keys!
      firm_params[:initial_advice_fee_structure_ids] = firm.initial_advice_fee_structure_ids
      firm_params[:ongoing_advice_fee_structure_ids] = firm.ongoing_advice_fee_structure_ids
      firm_params[:allowed_payment_method_ids] = firm.allowed_payment_method_ids
      firm_params[:investment_size_ids] = firm.investment_size_ids
      firm_params.merge(params)
    end

    describe 'GET #new' do
      context 'when not passed a lookup_id' do
        it 'raises a 404' do
          expect { get :new }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when not passed a non-existent lookup_id' do
        it 'raises a 404' do
          expect { get :new, lookup_id: '9999999' }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when passed a lookup_id' do
        before { get :new, lookup_id: lookup_subsidiary.id }

        it 'assigns a new firm with the name & fca number of the lookup firm' do
          expect(assigns(:firm).registered_name).to eq lookup_subsidiary.name
          expect(assigns(:firm).fca_number).to eq lookup_subsidiary.fca_number
        end

        it 'assigns a new firm with the parent id of the principal’s firm' do
          expect(assigns(:firm).parent_id).to eq firm.id
        end

        it 'renders the new page' do
          expect(subject).to render_template 'self_service/trading_names/new'
        end
      end
    end

    describe 'POST #create' do
      context 'when passed valid details' do
        let(:firm_params) { build_firm_params }
        before { post :create, firm: firm_params, lookup_id: lookup_subsidiary.id }

        it 'creates the firm' do
          expect(firm.trading_names.max_by(&:id).email_address).to eq firm_params[:email_address]
        end

        it 'assigns the firm to the principal’s firm' do
          expect(firm.trading_names.max_by(&:id).parent_id).to eq firm.id
        end

        it 'redirects to the edit page' do
          redirect_path = edit_self_service_trading_name_path(assigns(:firm))
          expect(response).to redirect_to redirect_path
        end
      end

      context 'when passed invalid details' do
        let(:firm_params) { build_firm_params(email_address: 'not_valid') }
        before { post :create, firm: firm_params, lookup_id: lookup_subsidiary.id }

        it 'does not create the firm' do
          expect(firm.trading_names).to be_empty
        end

        it 'renders the new page' do
          expect(response).to render_template 'self_service/trading_names/new'
        end
      end
    end
  end
end
