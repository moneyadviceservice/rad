RSpec.describe SelfService::BaseController, type: :controller do
  include Devise::Test::ControllerHelpers
  before { sign_in(user) }

  let(:user) { FactoryBot.create(:user, principal: principal) }
  let(:principal) { FactoryBot.create(:principal, manually_build_firms: true) }

  describe 'GET #choose_firm_type' do
    subject { get :choose_firm_type }

    context 'when principal has a retirement advise firm' do
      let!(:firm) { create(:firm, principal: principal) }
      it 'redirects to self service firms path' do
        expect(subject).to redirect_to(self_service_firms_path)
      end
    end

    context 'when principal has a travel insurance firm' do
      let!(:firm) { create(:travel_insurance_firm, principal: principal) }
      it 'redirects to travel insurance self service path' do
        expect(subject).to redirect_to(self_service_travel_insurance_firms_path)
      end
    end
  end
end
