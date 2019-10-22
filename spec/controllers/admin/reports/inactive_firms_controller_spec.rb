RSpec.describe Admin::Reports::InactiveFirmsController, type: :request do
  describe '#show' do
    it 'successfully renders' do
      get admin_reports_inactive_firm_path
      expect(response).to be_success
    end

    it 'assigns a list of inactive firms' do
      FactoryBot.create(:lookup_firm, fca_number: 123_456)
      FactoryBot.create(:firm, fca_number: 123_456)

      inactive_firm = FactoryBot.create(:firm, fca_number: 789_012)
      FactoryBot.create(:firm, fca_number: 789_012, parent: inactive_firm)

      get admin_reports_inactive_firm_path
      expect(response.body).to include(inactive_firm.registered_name)
    end

    context 'CSV format' do
      it 'renders the csv template' do
        get admin_reports_inactive_firm_path, params: { format: :csv }
        expect(response).to be_success
      end

      it 'sets the content type to "text/csv"' do
        get admin_reports_inactive_firm_path, params: { format: :csv }
        expect(response.content_type).to eq('text/csv')
      end

      it 'has the appropriate csv headers' do
        get admin_reports_inactive_firm_path, params: { format: :csv }
        expect(response.body).to include('FCA Number,Registered Name,Visible on Directory?')
      end

      it 'renders inactive adviser content' do
        FactoryBot.create(:firm, fca_number: 789_012, registered_name: 'Acme Finance')

        get admin_reports_inactive_firm_path, params: { format: :csv }
        expect(response.body).to include('789012,Acme Finance,Yes')
      end
    end
  end
end
