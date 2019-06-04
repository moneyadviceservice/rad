RSpec.describe SelfService::TradingNamesController, type: :controller do
  let(:principal) { FactoryGirl.create(:principal) }
  let(:firm) do
    firm_attrs = FactoryGirl.attributes_for(:firm, fca_number: principal.fca_number)
    principal.firm.update_attributes(firm_attrs)
    principal.firm
  end
  let(:user) { FactoryGirl.create :user, principal: firm.principal }
  let(:lookup_subsidiary) { FactoryGirl.create(:lookup_subsidiary, fca_number: principal.fca_number) }
  
  include_context 'fca api ok response'

  before { sign_in(user) }

  def build_firm_params(params = {})
    firm = params[:firm] || FactoryGirl.build(:firm)
    firm_params = firm.attributes
    firm_params.symbolize_keys!
    firm_params.merge!(
      initial_advice_fee_structure_ids: firm.initial_advice_fee_structure_ids,
      ongoing_advice_fee_structure_ids: firm.ongoing_advice_fee_structure_ids,
      allowed_payment_method_ids: firm.allowed_payment_method_ids,
      investment_size_ids: firm.investment_size_ids,
      primary_advice_method: firm.primary_advice_method,
      other_advice_method_ids: firm.other_advice_method_ids,
      in_person_advice_method_ids: firm.in_person_advice_method_ids,
      status: firm.status
    )
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
        expect(assigns(:firm).persisted?).to be_truthy
        expect(assigns(:firm).website_address).to eq firm_params[:website_address]
      end

      it 'assigns the firm to the principal’s firm' do
        expect(assigns(:firm).parent_id).to eq firm.id
      end

      it 'redirects to the edit page' do
        redirect_path = edit_self_service_trading_name_path(assigns(:firm))
        expect(response).to redirect_to redirect_path
      end
    end

    context 'when passed invalid details' do
      let(:firm_params) { build_firm_params(website_address: 'not_valid') }
      before { post :create, firm: firm_params, lookup_id: lookup_subsidiary.id }

      it 'does not create the firm' do
        expect(firm.trading_names).to be_empty
      end

      it 'renders the new page' do
        expect(response).to render_template 'self_service/trading_names/new'
      end
    end
  end

  describe 'GET #edit' do
    let!(:trading_name) { create :firm, parent: firm }
    context 'when accessing current users firm' do
      before { get :edit, id: trading_name.id }

      it 'assigns the trading name' do
        expect(assigns(:firm)).to eq trading_name
      end

      it 'renders the edit page' do
        expect(response).to render_template 'self_service/trading_names/edit'
      end
    end

    context 'when trying to access another users trading_name' do
      let!(:other_principal) { create :principal }

      it 'does not assign the other principals trading names' do
        other_trading_name = create :firm, parent: other_principal.firm
        expect { get :edit, id: other_trading_name.id }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:trading_name) { create :firm, parent: firm }
    let(:trading_name_params) { build_firm_params(firm: trading_name, website_address: 'http://www.valid.com') }
    context 'when passed valid details' do
      before { patch :update, id: trading_name.id, firm: trading_name_params }

      it 'updates the trading_name' do
        expect(trading_name.reload.website_address).to eq trading_name_params[:website_address]
      end

      it 'redirects to the edit page' do
        redirect_path = edit_self_service_trading_name_path(id: trading_name.id)
        expect(response).to redirect_to redirect_path
      end
    end

    context 'when trying to access another users trading_name' do
      let!(:other_principal) { create :principal }
      let(:trading_name_params) { build_firm_params(firm: trading_name, website_address: 'http://www.valid.com') }

      it 'fails to respond successfully' do
        other_trading_name = create :firm, parent: other_principal.firm
        expect { patch :update, id: other_trading_name.id, firm: trading_name_params }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when passed invalid details' do
      let(:firm_params) { build_firm_params(firm: trading_name, website_address: 'not_valid') }
      before { patch :update, id: trading_name.id, firm: firm_params }

      it 'does not update the firm' do
        expect(trading_name.reload.website_address).not_to eq firm_params[:website_address]
      end

      it 'renders the edit page' do
        expect(response).to render_template 'self_service/trading_names/edit'
      end
    end
  end
end
