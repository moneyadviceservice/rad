RSpec.describe Admin::Reports::InactiveAdvisersController, type: :controller do
  describe '#show' do
    it 'successfully renders' do
      get :show
      expect(response).to be_success
    end

    it 'assigns a list of inactive advisers' do
      FactoryGirl.create(:adviser)
      inactive_adviser = FactoryGirl.build(:adviser, create_linked_lookup_advisor: false)
      inactive_adviser.save!(validate: false)

      get :show
      expect(assigns[:inactive_advisers]).to eq([inactive_adviser])
    end

    it 'excludes advisers that have skipped the reference number check' do
      FactoryGirl.create(:adviser)
      noref_adviser = FactoryGirl.build(:adviser,
                                        bypass_reference_number_check: true,
                                        create_linked_lookup_advisor: false)

      noref_adviser.save!(validate: false)

      get :show
      expect(assigns[:inactive_advisers]).to eq([])
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
        expect(response.body).to include('Ref Number,Name,Firm')
      end

      it 'renders inactive adviser content' do
        firm = FactoryGirl.create(:firm, registered_name: 'Acme Inc.')
        inactive_adviser = FactoryGirl.build(:adviser,
                                             create_linked_lookup_advisor: false,
                                             reference_number: 123_456,
                                             name: 'Amear Pittance',
                                             firm: firm)
        inactive_adviser.save!(validate: false)

        get :show, format: :csv
        expect(response.body).to include('123456,Amear Pittance,Acme Inc.')
      end
    end
  end
end
