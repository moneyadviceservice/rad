RSpec.describe Admin::Reports::InactiveTradingNamesController, type: :controller do
  describe '#show' do
    it 'successfully renders' do
      get :show
      expect(response).to be_success
    end

    it 'assigns a list of inactive trading names' do
      firm = FactoryGirl.create(:firm, fca_number: 123456)

      FactoryGirl.create(:lookup_subsidiary, name: 'Acme', fca_number: 123456)
      FactoryGirl.create(:firm, registered_name: 'Acme', fca_number: 123456, parent: firm)
      inactive_trading_name = FactoryGirl.create(:firm, registered_name: 'Not Acme', fca_number: 123456, parent: firm)

      get :show
      expect(assigns[:inactive_trading_names]).to eq([inactive_trading_name])
    end
  end
end
