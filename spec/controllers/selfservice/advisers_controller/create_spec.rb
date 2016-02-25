module SelfService
  RSpec.describe SelfService::AdvisersController, type: :controller,
                                                  vcr: vcr_options_for(:adviser_controller_create_spec) do
    include_context 'advisers controller'

    let(:postcode) { 'EH1 2AS' }

    describe '#create' do
      let(:reference_number) { FactoryGirl.create(:lookup_adviser).reference_number }
      specify { expect_create_to_set reference_number: reference_number, postcode: 'EH1 2AS' }
      specify { expect_create_to_set reference_number: reference_number, travel_distance: 250 }

      context 'with valid params' do
        let(:lookup_adviser) { FactoryGirl.create :lookup_adviser }
        let(:adviser_params) do
          FactoryGirl.attributes_for(:adviser,
                                     reference_number: lookup_adviser.reference_number,
                                     postcode: postcode)
        end
        before { post :create, firm_id: firm.id, adviser: adviser_params }

        it 'creates a new adviser' do
          expect(assigns(:adviser)).to be_valid
          expect(assigns(:adviser)).to be_an Adviser
        end

        it 'redirects to the adviser index page' do
          redirect_path = self_service_firm_advisers_path(firm)
          expect(response).to redirect_to redirect_path
        end

        it 'adds a success flash message' do
          expect(flash[:notice]).to eq(I18n.t('self_service.adviser_edit.saved'))
        end
      end

      context 'with invalid params' do
        let(:adviser_params) { FactoryGirl.attributes_for(:adviser, reference_number: 'Q') }
        before { post :create, firm_id: firm.id, adviser: adviser_params }

        it 'renders the adviser new page' do
          expect(response).to render_template :new
        end
      end
    end

    def expect_create_to_set(attributes)
      valid_attributes = FactoryGirl.attributes_for(:adviser, postcode: postcode)
      post :create, firm_id: firm.id, adviser: valid_attributes.merge(attributes)
      attributes.each do |key, value|
        expect(assigns(:adviser).send(key)).to eq(value)
      end
    end
  end
end
