module SelfService
  RSpec.describe SelfService::OfficesController, type: :request do
    include_context 'offices controller'

    describe '#create' do
      context 'with valid params' do
        before { post :create, firm_id: firm.id, office: valid_attributes }

        it 'creates a new office' do
          expect(assigns(:office)).to be_valid
          expect(assigns(:office)).to be_an Office
        end

        it 'redirects to the office index page' do
          redirect_path = self_service_firm_offices_path(firm)
          expect(response).to redirect_to redirect_path
        end

        it 'adds a success flash message' do
          expect(flash[:notice]).to eq(I18n.t('self_service.office_add.saved'))
        end
      end

      context 'with invalid params' do
        it 'renders the office new page' do
          post :create, firm_id: firm.id, office: { rubbish: 666 }
          expect(response).to render_template :new
        end
      end
    end
  end
end
