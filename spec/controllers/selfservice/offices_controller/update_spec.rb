module SelfService
  RSpec.describe SelfService::OfficesController, type: :controller do
    include_context 'fca api ok response'
    include_context 'offices controller'

    describe '#update' do
      context 'with valid params' do
        let(:email_change) { { email_address: 'bobby@example.com' } }

        before do
          patch :update, firm_id: firm.id, id: office.id, office: valid_attributes.merge(email_change)
        end

        it 'updates the model' do
          expect(office.reload.email_address).to eq('bobby@example.com')
        end

        it 'adds a success message after successfully updating the adviser' do
          expect(flash[:notice]).to eq(I18n.t('self_service.office_edit.saved'))
        end

        it 'redirects to the adviser index page' do
          redirect_path = self_service_firm_offices_path(assigns(:firm))
          expect(response).to redirect_to redirect_path
        end
      end

      context 'with invalid params' do
        it 'renders the office edit page' do
          patch :update, firm_id: firm.id, id: office.id, office: { address_line_one: '' }
          expect(response).to render_template :edit
        end
      end
    end
  end
end
