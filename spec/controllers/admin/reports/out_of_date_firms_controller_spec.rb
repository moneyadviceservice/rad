RSpec.describe Admin::Reports::OutOfDateFirmsController, type: :request do
  describe '#index' do
    it 'successfully renders' do
      get :index
      expect(response).to be_success
    end

    it 'lists firms where the name has gone out of sync with the lookup data' do
      FactoryBot.create(:lookup_firm, registered_name: 'Finance Co.', fca_number: 111_111)
      FactoryBot.create(:firm, registered_name: 'Finance Co.', fca_number: 111_111)

      FactoryBot.create(:lookup_firm, registered_name: 'Acme Inc', fca_number: 222_222)
      firm = FactoryBot.create(:firm, registered_name: 'Acme Finance', fca_number: 222_222)

      get :index
      expect(assigns[:firms]).to eq([[222_222, 'Acme Inc', 'Acme Finance', firm.id]])
    end
  end

  describe '#update' do
    it 'replaces the name of the firm with the name from the lookup firm' do
      FactoryBot.create(:lookup_firm, registered_name: 'Acme Inc', fca_number: 222_222)
      firm = FactoryBot.create(:firm, registered_name: 'Acme Finance', fca_number: 222_222)

      patch :update, id: firm.id

      expect(Firm.find_by(fca_number: 222_222).registered_name).to eq('Acme Inc')
    end
  end
end
