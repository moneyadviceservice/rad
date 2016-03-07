RSpec.describe Admin::Reports::OutOfDateFirmsController, type: :controller do
  describe '#show' do
    it 'successfully renders' do
      get :show
      expect(response).to be_success
    end

    it 'lists firms where the name has gone out of sync with the lookup data' do
      FactoryGirl.create(:lookup_firm, registered_name: 'Finance Co.', fca_number: 111111)
      FactoryGirl.create(:firm, registered_name: 'Finance Co.', fca_number: 111111)

      FactoryGirl.create(:lookup_firm, registered_name: 'Acme Inc', fca_number: 222222)
      firm = FactoryGirl.create(:firm, registered_name: 'Acme Finance', fca_number: 222222)

      get :show
      expect(assigns[:firms]).to eq([[222222, 'Acme Finance', firm.id, 'Acme Inc']])
    end

    describe 'names to be intentionally ignored' do
      described_class::REGISTERED_NAMES_TO_IGNORE.each do |name|
        it "allows the name '#{name}'" do
          FactoryGirl.create(:lookup_firm, registered_name: 'Different Name', fca_number: 111111)
          FactoryGirl.create(:firm, registered_name: name, fca_number: 111111)

          get :show
          expect(assigns[:firms]).to eq([])
        end
      end
    end
  end
end
