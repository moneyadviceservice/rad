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
      FactoryGirl.create(:firm, fca_number: 789012, parent: inactive_firm)

      get :show
      expect(assigns[:inactive_firms]).to eq([inactive_firm])
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
        FactoryGirl.create(:firm, fca_number: 789012, registered_name: 'Acme Finance')

        get :show, format: :csv
        expect(response.body).to include('789012,Acme Finance,Yes')
      end
    end
  end
end
