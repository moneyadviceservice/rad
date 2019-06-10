module SelfService
  RSpec.describe SelfService::AdvisersController, type: :controller do
    include_context 'fca api ok response'
    include_context 'advisers controller'

    describe '#update' do
      specify { expect_update_to_change postcode: 'EH1 2AS' }
      specify { expect_update_to_change travel_distance: 250 }

      context 'with a valid lookup_adviser' do
        let(:new_reference_number) { 'ABC22222' }
        before { FactoryGirl.create :lookup_adviser, reference_number: new_reference_number }

        it { expect_update_to_change reference_number: new_reference_number }
      end

      context 'with valid params' do
        let(:adviser_params) { { postcode: 'EH1 3DX' } }
        before do
          patch :update, firm_id: firm.id, id: adviser.id, adviser: adviser_params
        end

        it 'adds a success message after successfully updating the adviser' do
          expect(flash[:notice]).to eq(I18n.t('self_service.adviser_edit.saved'))
        end

        it 'redirects to the adviser index page' do
          redirect_path = self_service_firm_advisers_path(assigns(:firm))
          expect(response).to redirect_to redirect_path
        end
      end
    end

    def expect_update_to_change(attributes)
      patch :update, firm_id: firm.id, id: adviser.id, adviser: attributes
      adviser.reload
      attributes.each do |key, value|
        expect(adviser.send(key)).to eq(value)
      end
    end
  end
end
