RSpec.describe Admin::Reports::InactiveAdvisersController, type: :request do
  describe '#show' do
    it 'successfully renders' do
      get admin_reports_inactive_adviser_path
      expect(response).to be_successful
    end

    it 'assigns a list of inactive advisers' do
      FactoryBot.create(:adviser)
      inactive_adviser = FactoryBot.build(:adviser, create_linked_lookup_advisor: false)
      inactive_adviser.save!(validate: false)

      get admin_reports_inactive_adviser_path
      expect(response.body).to include(CGI.escapeHTML(inactive_adviser.name))
    end

    it 'excludes advisers that have skipped the reference number check' do
      FactoryBot.create(:adviser)
      noref_adviser = FactoryBot.build(
        :adviser,
        bypass_reference_number_check: true,
        create_linked_lookup_advisor: false
      )

      noref_adviser.save!(validate: false)

      get admin_reports_inactive_adviser_path
      expect(response.body).to_not include(noref_adviser.name)
    end

    context 'CSV format' do
      it 'renders the csv template' do
        get admin_reports_inactive_adviser_path, params: { format: :csv }
        expect(response).to be_successful
      end

      it 'sets the content type to "text/csv"' do
        get admin_reports_inactive_adviser_path, params: { format: :csv }
        expect(response.content_type).to eq('text/csv')
      end

      it 'has the appropriate csv headers' do
        get admin_reports_inactive_adviser_path, params: { format: :csv }
        expect(response.body).to include('Ref Number,Name,Firm')
      end

      it 'renders inactive adviser content' do
        firm = FactoryBot.create(:firm, registered_name: 'Acme Inc.')
        inactive_adviser = FactoryBot.build(
          :adviser,
          create_linked_lookup_advisor: false,
          reference_number: 123_456,
          name: 'Amear Pittance',
          firm: firm
        )
        inactive_adviser.save!(validate: false)

        get admin_reports_inactive_adviser_path, params: { format: :csv }
        expect(response.body).to include('123456,Amear Pittance,Acme Inc.')
      end
    end
  end
end
