module SelfService
  RSpec.describe SelfService::OfficesController, type: :controller,
                                                  vcr: vcr_options_for(:features_self_service_offices_add_spec) do
    include_context 'offices controller'

    let(:address_line_one) { '120 Holborn' }
    let(:address_line_two) { 'Floor 5' }
    let(:postcode)         { 'EC1N 2TD' }

    let(:valid_attributes) do
      FactoryGirl.attributes_for(
        :office,
        address_line_one: address_line_one,
        address_line_two: address_line_two,
        address_postcode: postcode
      )
    end

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
