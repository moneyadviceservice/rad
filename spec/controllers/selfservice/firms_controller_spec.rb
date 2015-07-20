RSpec.describe SelfService::FirmsController, type: :controller do
  let(:principal) { FactoryGirl.create(:principal) }
  let(:firm) do
    firm_attrs = FactoryGirl.attributes_for(:firm_with_trading_names, fca_number: principal.fca_number)
    principal.firm.update_attributes(firm_attrs)
    principal.firm
  end
  let(:user) { FactoryGirl.create :user, principal: firm.principal }
  before { sign_in(user) }

  def extract_firm_params(firm, params = {})
    firm_params = firm.attributes
    firm_params.symbolize_keys!
    firm_params[:initial_advice_fee_structure_ids] = firm.initial_advice_fee_structure_ids
    firm_params[:ongoing_advice_fee_structure_ids] = firm.ongoing_advice_fee_structure_ids
    firm_params[:allowed_payment_method_ids] = firm.allowed_payment_method_ids
    firm_params[:investment_size_ids] = firm.investment_size_ids
    firm_params[:remote_or_local_advice] = firm.remote_or_local_advice
    firm_params[:other_advice_method_ids] = firm.other_advice_method_ids
    firm_params[:in_person_advice_method_ids] = firm.in_person_advice_method_ids
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
        trading_name.email_address = nil
        trading_name.save(validate: false)
      end

      it 'assigns only registered trading names' do
        get :index
        expect(assigns(:presenter)).to have(2).trading_names
      end
    end

    context 'when there are lookup names' do
      before { FactoryGirl.create_list(:lookup_subsidiary, 8, fca_number: firm.fca_number) }

      it 'assigns lookup names' do
        get :index
        expect(assigns(:presenter)).to have(8).lookup_names
      end

      it 'sorts lookup names by lowercase name (alpha ascending)' do
        get :index
        assigned_names = assigns(:presenter).lookup_names.map(&:name)
        sorted_names = assigned_names.sort_by(&:downcase)

        expect(assigned_names).to eq sorted_names
      end
    end
  end

  describe 'GET #edit' do
    let(:trading_name) { FactoryGirl.create(:firm, parent_id: firm.id) }
    before { get :edit, id: firm.id }

    it 'assigns the firm' do
      expect(assigns(:firm)).to eq firm
    end

    it 'renders the edit page' do
      expect(response).to render_template 'self_service/firms/edit'
    end
  end

  describe 'PATCH #update' do
    let(:firm) { FactoryGirl.create(:firm) }

    context 'when passed valid details' do
      let(:firm_params) { extract_firm_params(firm, email_address: 'valid@example.com') }
      before { patch :update, id: firm.id, firm: firm_params }

      it 'updates the firm' do
        expect(firm.reload.email_address).to eq firm_params[:email_address]
      end

      it 'redirects to the edit page' do
        redirect_path = edit_self_service_firm_path(assigns(:firm))
        expect(response).to redirect_to redirect_path
      end
    end

    context 'when passed invalid details' do
      let(:firm_params) { extract_firm_params(firm, email_address: 'not_valid') }
      before { patch :update, id: firm.id, firm: firm_params }

      it 'does not update the firm' do
        expect(firm.reload.email_address).not_to eq firm_params[:email_address]
      end

      it 'renders the edit page' do
        expect(response).to render_template 'self_service/firms/edit'
      end
    end

    context 'when the advice type is changed from local to remote' do
      let(:other_advice_method_ids) { create_list(:other_advice_method, rand(1..3)).map(&:id) }
      let(:firm_params) do
        extract_firm_params(firm, remote_or_local_advice: :remote,
                                  other_advice_method_ids: other_advice_method_ids)
      end
      before { patch :update, id: firm.id, firm: firm_params }

      it 'clears the local advice types' do
        expect(firm.reload.in_person_advice_methods).to be_empty
      end

      it 'sets the remote advice types' do
        expect(firm.reload.other_advice_method_ids).to eq other_advice_method_ids
      end
    end
  end
end
