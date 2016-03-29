RSpec.feature 'Searching for advisers on the admin interface' do
  let(:the_page) { Admin::AdvisersIndexPage.new }

  before do
    given_there_are_advisers
    given_i_am_on_the_admin_advisers_index_page
    then_i_see_all_advisers
  end

  scenario 'Filtering by Ref number' do
    when_i_filter_by reference_number: 'CHP12345'
    then_i_see_n_results(1)
    then_i_only_see_advisers_with reference_number: 'CHP12345'

    when_i_clear_all_filters
    then_i_see_all_advisers
  end

  scenario 'Filtering by adviser name' do
    when_i_filter_by name: 'Wes Montgomery'
    then_i_see_n_results(1)
    then_i_only_see_advisers_with name: 'Wes Montgomery'

    when_i_clear_all_filters
    then_i_see_all_advisers
  end

  scenario 'Filtering by firm name' do
    when_i_filter_by firm_registered_name: 'W. Montgomery Financial'
    then_i_see_n_results(2)
    then_i_only_see_advisers_with firm_registered_name: 'W. Montgomery Financial'

    when_i_clear_all_filters
    then_i_see_all_advisers
  end

  scenario 'Filtering by postcode' do
    when_i_filter_by postcode: 'EH3 1DY'
    then_i_see_n_results(1)
    then_i_only_see_advisers_with postcode: 'EH3 1DY'

    when_i_clear_all_filters
    then_i_see_all_advisers
  end

  def given_i_am_on_the_admin_advisers_index_page
    the_page.load
    expect(the_page).to be_displayed
    expect_no_errors
  end

  def given_there_are_advisers
    FactoryGirl.create(:firm_without_advisers, registered_name: 'W. Montgomery Financial') do |f|
      FactoryGirl.create(:adviser, firm: f, name: 'Wes Montgomery')
      FactoryGirl.create(:adviser, firm: f, postcode: 'EH3 1DY')
    end

    FactoryGirl.create(:adviser, reference_number: 'CHP12345')

    @advisers = Adviser.all.to_a
  end

  def when_i_clear_all_filters
    the_page.clear_form
    submit_the_form
  end

  def when_i_filter_by(field_values)
    the_page.fill_out_form(field_values)
    submit_the_form
  end

  def then_i_see_n_results(expected_count)
    expect(the_page.total_advisers).to eq(expected_count)
  end

  def then_i_only_see_advisers_with(expected_common_attrs)
    expect(the_page.advisers).to rspec_all(have_attributes(expected_common_attrs))
  end

  def then_i_see_all_advisers
    expect(the_page.total_advisers).to eq(@advisers.count)
    expect(the_page.advisers.count).to eq(@advisers.count)
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
