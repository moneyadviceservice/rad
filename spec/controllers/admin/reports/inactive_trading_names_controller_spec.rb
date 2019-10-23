RSpec.describe Admin::Reports::InactiveTradingNamesController, type: :request do
  describe '#show' do
    it 'successfully renders' do
      get admin_reports_inactive_trading_name_path
      expect(response).to be_success
    end

    it 'assigns a list of inactive trading names' do
      firm = FactoryBot.create(:firm, fca_number: 123_456)

      FactoryBot.create(:lookup_subsidiary, name: 'Acme', fca_number: 123_456)
      FactoryBot.create(:firm, registered_name: 'Acme', fca_number: 123_456, parent: firm)
      inactive_trading_name = FactoryBot.create(:firm, registered_name: 'Not Acme', fca_number: 123_456, parent: firm)

      get admin_reports_inactive_trading_name_path
      expect(response.body).to include(inactive_trading_name.registered_name)
    end

    it 'assigns a list of inactive trading names' do
      firm = FactoryBot.create(:firm, fca_number: 123_456)

      FactoryBot.create(:lookup_subsidiary, name: 'Acme', fca_number: 123_456)
      FactoryBot.create(:firm, registered_name: 'Acme', fca_number: 123_456, parent: firm)
      inactive_trading_name = FactoryBot.create(:firm, registered_name: 'Not Acme', fca_number: 123_456, parent: firm)

      get admin_reports_inactive_trading_name_path
      expect(response.body).to include(inactive_trading_name.registered_name)
    end

    context 'CSV format' do
      it 'renders the csv template' do
        get admin_reports_inactive_trading_name_path, format: :csv
        expect(response).to be_success
      end

      it 'sets the content type to "text/csv"' do
        get admin_reports_inactive_trading_name_path, format: :csv
        expect(response.content_type).to eq('text/csv')
      end

      it 'has the appropriate csv headers' do
        get admin_reports_inactive_trading_name_path, format: :csv
        expect(response.body).to include('FCA Number,Registered Name,Visible on Directory?')
      end

      it 'renders inactive adviser content' do
        firm = FactoryBot.create(:firm, fca_number: 123_456)
        FactoryBot.create(:firm, fca_number: 789_012, registered_name: 'Acme Finance', parent: firm)

        get admin_reports_inactive_trading_name_path, format: :csv
        expect(response.body).to include('789012,Acme Finance,Yes')
      end
    end
  end
end
