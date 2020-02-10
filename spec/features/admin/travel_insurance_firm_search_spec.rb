RSpec.feature 'Searching for travel insurance firms on the admin interface' do
  let(:the_page) { Admin::TravelInsuranceFirmsIndexPage.new }

  before do
    given_there_are_firms
    given_i_am_on_the_admin_travel_insurance_firms_index_page
    then_i_see_all_firms
  end

  scenario 'Filtering by FCA number' do
    when_i_filter_by fca_number: '123456'
    then_i_see_n_results(1)

    when_i_clear_all_filters
    then_i_see_all_firms
  end

  scenario 'Filtering by firm name' do
    when_i_filter_by registered_name: 'Acme Finance'
    then_i_see_n_results(1)
    then_i_only_see_firms_with registered_name: 'Acme Finance'

    when_i_clear_all_filters
    then_i_see_all_firms
  end

  def given_i_am_on_the_admin_travel_insurance_firms_index_page
    the_page.load
    expect(the_page).to be_displayed
    expect_no_errors
  end

  def given_there_are_firms
    @firms = [
      FactoryBot.create(
        :travel_insurance_firm, registered_name: 'Acme Finance'
      ),
      FactoryBot.create(:travel_insurance_firm, fca_number: '123456'),
      FactoryBot.create(:travel_insurance_firm, fca_number: '123457'),
      FactoryBot.create(:travel_insurance_firm, registered_name: 'Travel #4'),
      FactoryBot.create(:travel_insurance_firm, registered_name: 'Travel #5'),
      FactoryBot.create(:travel_insurance_firm, registered_name: 'Travel #6'),
      FactoryBot.create(:travel_insurance_firm, registered_name: 'Travel #7')
    ]
  end

  def when_i_clear_all_filters
    the_page.clear_form
    submit_the_form
  end

  def when_i_filter_by(field_values)
    the_page.clear_form
    the_page.fill_out_form(field_values)
    submit_the_form
  end

  def then_i_see_n_results(expected_count)
    expect(the_page.total_firms).to eq(expected_count)
  end

  def then_i_only_see_firms_with(expected_common_attrs)
    expect(the_page.firms).to rspec_all(have_attributes(expected_common_attrs))
  end

  def then_i_only_see_firms(*expected_firm_names)
    expect(the_page.firms.map(&:registered_name)).to match_array(expected_firm_names)
  end

  def then_i_see_all_firms
    expect(the_page.total_firms).to eq(@firms.count)
    expect(the_page.firms.count).to eq(@firms.count)
  end

  def expect_no_errors
    return unless status_code == 500

    expect(the_page).not_to have_text %r{[Ee]rror|[Ww]arn|[Ee]xception}
  end

  def submit_the_form
    the_page.submit.click
    expect_no_errors
  end
end
