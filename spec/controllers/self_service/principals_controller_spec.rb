RSpec.describe SelfService::PrincipalsController, type: :controller do
  before { sign_in(user) }
  let(:user) { FactoryBot.create(:user, principal: principal) }
  let(:principal) { FactoryBot.create(:principal) }

  describe 'GET #edit' do
    before { get :edit, id: principal.id }

    it 'renders the edit action' do
      expect(subject).to render_template 'self_service/principals/edit'
    end

    it 'provides the principal object' do
      expect(assigns(:principal)).to eq principal
    end
  end

  describe 'PATCH #update' do
    before { patch :update, id: principal.id, principal: principal_params }

    context 'with valid parameters' do
      let(:principal_params) { FactoryBot.attributes_for(:principal) }

      it 'saves the record' do
        principal = assigns(:principal).reload
        expect(principal.first_name).to eq principal_params[:first_name]
        expect(principal.last_name).to eq principal_params[:last_name]
        expect(principal.email_address).to eq principal_params[:email_address]
        expect(principal.job_title).to eq principal_params[:job_title]
        expect(principal.telephone_number).to eq principal_params[:telephone_number]
      end

      it 'redirects to the edit action' do
        expect(response).to redirect_to edit_self_service_principal_path(principal)
      end
    end

    context 'with invalid paramters' do
      let(:principal_params) { { email_address: 'no' } }

      it 'does not save the record' do
        expect(principal.reload.email_address).to_not eq principal_params[:email_address]
      end

      it 'renders the edit template' do
        expect(response).to render_template 'self_service/principals/edit'
      end
    end
  end
end
