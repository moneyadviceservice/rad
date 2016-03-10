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
  end
end
