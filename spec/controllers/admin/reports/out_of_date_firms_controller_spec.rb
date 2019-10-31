RSpec.describe Admin::Reports::OutOfDateFirmsController, type: :request do
  describe '#index' do
    it 'successfully renders' do
      get admin_reports_out_of_date_firms_path
      expect(response).to be_successful
    end

    it 'lists firms where the name has gone out of sync with the lookup data' do
      FactoryBot.create(:lookup_firm, registered_name: 'Finance Co.', fca_number: 111_111)
      FactoryBot.create(:firm, registered_name: 'Finance Co.', fca_number: 111_111)
      FactoryBot.create(:lookup_firm, registered_name: 'Acme Inc', fca_number: 222_222)
      firm = FactoryBot.create(:firm, registered_name: 'Acme Finance', fca_number: 222_222)

      get admin_reports_out_of_date_firms_path

      expect(response.body).to include("Acme Inc")
      expect(response.body).to include("Acme Finance")
      expect(response.body).to_not include("Finance Co.")
    end
  end

  describe '#update' do
    it 'replaces the name of the firm with the name from the lookup firm' do
      FactoryBot.create(:lookup_firm, registered_name: 'Acme Inc', fca_number: 222_222)
      firm = FactoryBot.create(:firm, registered_name: 'Acme Finance', fca_number: 222_222)

      patch admin_reports_out_of_date_firm_path(firm)

      expect(Firm.find_by(fca_number: 222_222).registered_name).to eq('Acme Inc')
    end
  end
end
