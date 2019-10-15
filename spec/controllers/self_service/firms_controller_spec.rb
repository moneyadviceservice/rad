RSpec.describe SelfService::FirmsController, type: :request do
  let(:principal) { FactoryBot.create(:principal) }
  let(:firm) do
    firm_attrs = FactoryBot.attributes_for(:firm_with_trading_names, fca_number: principal.fca_number)
    principal.firm.update_attributes(firm_attrs)
    principal.firm
  end
  let(:user) { FactoryBot.create :user, principal: firm.principal }
  before { sign_in(user) }

  def extract_firm_params(firm, params = {})
    firm_params = firm.attributes
    firm_params.symbolize_keys!
    firm_params[:initial_advice_fee_structure_ids] = firm.initial_advice_fee_structure_ids
    firm_params[:ongoing_advice_fee_structure_ids] = firm.ongoing_advice_fee_structure_ids
    firm_params[:allowed_payment_method_ids] = firm.allowed_payment_method_ids
    firm_params[:investment_size_ids] = firm.investment_size_ids
    firm_params[:primary_advice_method] = firm.primary_advice_method
    firm_params[:other_advice_method_ids] = firm.other_advice_method_ids
    firm_params[:in_person_advice_method_ids] = firm.in_person_advice_method_ids
    firm_params[:status] = firm.status
    firm_params.merge(params)
  end

  describe 'GET #index' do
    it 'creates and assigns the presenter' do
      get :index
      expect(assigns(:presenter)).to be_a SelfService::FirmsIndexPresenter
    end

    context 'when all trading names are registered' do
      it 'assigns all trading names' do
        get :index
        expect(assigns(:presenter)).to have(3).trading_names
      end
    end

    context 'when some trading names are registered' do
      before do
        trading_name = firm.trading_names.first
        trading_name.__set_registered(false)
        trading_name.save(validate: false)
      end

      it 'assigns only registered trading names' do
        get :index
        expect(assigns(:presenter)).to have(2).trading_names
      end
    end

    context 'when there are lookup names' do
      before do
        FactoryBot.create(:lookup_subsidiary, fca_number: firm.fca_number, name: 'Bertie')
        FactoryBot.create(:lookup_subsidiary, fca_number: firm.fca_number, name: 'Anne')
        FactoryBot.create(:lookup_subsidiary, fca_number: firm.fca_number, name: 'Deirdre')
        FactoryBot.create(:lookup_subsidiary, fca_number: firm.fca_number, name: 'Colin')
      end

      it 'assigns lookup names' do
        get :index
        expect(assigns(:presenter)).to have(4).lookup_names
      end

      it 'sorts lookup names by lowercase name (alpha ascending)' do
        get :index
        assigned_names = assigns(:presenter).lookup_names.map(&:name)

        expect(assigned_names).to eq %w[Anne Bertie Colin Deirdre]
      end
    end
  end

  describe 'GET #edit' do
    let(:trading_name) { FactoryBot.create(:firm, parent_id: firm.id) }
    before { get :edit, id: firm.id }

    context 'when accessing current users firm' do
      before { get :edit, id: 'ignored' }

      it 'assigns the firm' do
        expect(assigns(:firm)).to eq firm
      end

      it 'renders the edit page' do
        expect(response).to render_template 'self_service/firms/edit'
      end
    end

    context 'when trying to access another users firm' do
      let!(:other_principal) { create :principal }
      before { get :edit, id: other_principal.firm.id }

      it 'does not assign the other principals firm' do
        expect(assigns(:firm)).not_to eq other_principal.firm
      end

      it 'assigns the current users firm' do
        expect(assigns(:firm)).to eq firm
      end
    end
  end

  describe 'PATCH #update' do
    let(:firm_params) { extract_firm_params(firm, website_address: 'http://www.valid.com') }
    context 'when passed valid details' do
      before { patch :update, id: 'ignored', firm: firm_params }

      it 'updates the firm' do
        expect(firm.reload.website_address).to eq firm_params[:website_address]
      end

      it 'redirects to the edit page' do
        redirect_path = edit_self_service_firm_path(id: 'ignored')
        expect(response).to redirect_to redirect_path
      end
    end

    context 'when the advice type is changed from local to remote' do
      let(:other_advice_method_ids) { create_list(:other_advice_method, rand(1..3)).map(&:id) }
      let(:firm_params) do
        extract_firm_params(firm, primary_advice_method: :remote,
                                  other_advice_method_ids: other_advice_method_ids)
      end
      before { patch :update, id: 'ignored', firm: firm_params }

      it 'clears the local advice types' do
        expect(firm.reload.in_person_advice_methods).to be_empty
      end

      it 'sets the remote advice types' do
        expect(firm.reload.other_advice_method_ids).to eq other_advice_method_ids
      end

      it 'redirects to the edit page' do
        redirect_path = edit_self_service_firm_path(id: 'ignored')
        expect(response).to redirect_to redirect_path
      end
    end

    context 'when trying to access another users firm' do
      let!(:other_principal) { create :principal }
      let!(:other_firm) { other_principal.firm }
      before { patch :update, id: other_firm.id, firm: firm_params }

      it 'fails to update the firm' do
        expect(other_firm.website_address).not_to eq('http://www.valid.com')
      end
    end

    context 'when passed invalid details' do
      let(:firm_params) { extract_firm_params(firm, website_address: 'not_valid') }
      before { patch :update, id: 'ignored', firm: firm_params }

      it 'does not update the firm' do
        expect(firm.reload.website_address).not_to eq firm_params[:website_address]
      end

      it 'renders the edit page' do
        expect(response).to render_template 'self_service/firms/edit'
      end
    end
  end
end
