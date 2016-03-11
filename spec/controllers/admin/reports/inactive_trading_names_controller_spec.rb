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

    context 'CSV format' do
      render_views

      it 'renders the csv template' do
        get :show, format: :csv
        expect(response).to render_template(:show)
      end

      it 'sets the content type to "text/csv"' do
        get :show, format: :csv
        expect(response.content_type).to eq('text/csv')
      end

      it 'has the appropriate csv headers' do
        get :show, format: :csv
        expect(response.body).to include('FCA Number,Registered Name,Visible on Directory?')
      end

      it 'renders inactive adviser content' do
        firm = FactoryGirl.create(:firm, fca_number: 123456)
        FactoryGirl.create(:firm, fca_number: 789012, registered_name: 'Acme Finance', parent: firm)

        get :show, format: :csv
        expect(response.body).to include('789012,Acme Finance,Yes')
      end
    end
  end
end
