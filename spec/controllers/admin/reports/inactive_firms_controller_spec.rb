RSpec.describe Admin::Reports::InactiveFirmsController, type: :controller do
  describe '#show' do
    it 'successfully renders' do
      get :show
      expect(response).to be_success
    end

    it 'assigns a list of inactive firms' do
      FactoryGirl.create(:lookup_firm, fca_number: 123456)
      FactoryGirl.create(:firm, fca_number: 123456)
      inactive_firm = FactoryGirl.create(:firm, fca_number: 789012)

      get :show
      expect(assigns[:inactive_firms]).to eq([inactive_firm])
    end
  end
end
