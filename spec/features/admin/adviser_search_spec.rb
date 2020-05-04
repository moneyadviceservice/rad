RSpec.feature 'Searching for advisers on the admin interface' do
  let(:the_page) { Admin::AdvisersIndexPage.new }

  let(:qualification_1) { FactoryBot.create(:qualification, name: 'Qual 1') }
  let(:qualification_2) { FactoryBot.create(:qualification, name: 'Qual 2') }
  let(:qualifications) { [qualification_1, qualification_2] }

  let(:accreditation_1) { FactoryBot.create(:accreditation, name: 'Accr 1') }
  let(:accreditation_2) { FactoryBot.create(:accreditation, name: 'Accr 2') }
  let(:accreditations) { [accreditation_1, accreditation_2] }

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

  scenario 'Filtering by qualifications' do
    when_i_filter_by qualifications: 'Qual 1'
    then_i_see_n_results(2)
    then_i_only_see_advisers 'A1', 'A2'

    when_i_filter_by qualifications: 'Qual 2'
    then_i_see_n_results(1)
    then_i_only_see_advisers 'A1'

    when_i_clear_all_filters
    then_i_see_all_advisers
  end

  scenario 'Filtering by accreditations' do
    when_i_filter_by accreditations: 'Accr 1'
    then_i_see_n_results(2)
    then_i_only_see_advisers 'A2', 'A3'

    when_i_filter_by accreditations: 'Accr 2'
    then_i_see_n_results(1)
    then_i_only_see_advisers 'A3'

    when_i_clear_all_filters
    then_i_see_all_advisers
  end

  scenario 'Filtering by qualifications and accreditations' do
    when_i_filter_by accreditations: 'Accr 1', qualifications: 'Qual 1'
    then_i_see_n_results(1)
    then_i_only_see_advisers 'A2'

    when_i_clear_all_filters
    then_i_see_all_advisers
  end

  def given_i_am_on_the_admin_advisers_index_page
    the_page.load
    expect(the_page).to be_displayed
    expect_no_errors
  end

  def given_there_are_advisers
    FactoryBot.create(:firm_without_advisers, registered_name: 'W. Montgomery Financial') do |f|
      FactoryBot.create(:advisers_retirement_firm, firm: f, name: 'Wes Montgomery')
      FactoryBot.create(:advisers_retirement_firm, firm: f, postcode: 'EH3 1DY')
    end

    FactoryBot.create(:advisers_retirement_firm, reference_number: 'CHP12345')

    FactoryBot.create(:advisers_retirement_firm,
                       name: 'A1',
                       qualifications: qualifications.take(2),
                       accreditations: accreditations.take(0))
    FactoryBot.create(:advisers_retirement_firm,
                       name: 'A2',
                       qualifications: qualifications.take(1),
                       accreditations: accreditations.take(1))
    FactoryBot.create(:advisers_retirement_firm,
                       name: 'A3',
                       qualifications: qualifications.take(0),
                       accreditations: accreditations.take(2))

    @advisers = Adviser.all.to_a
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
    expect(the_page.total_advisers).to eq(expected_count)
  end

  def then_i_only_see_advisers_with(expected_common_attrs)
    expect(the_page.advisers).to rspec_all(have_attributes(expected_common_attrs))
  end

  def then_i_only_see_advisers(*expected_adviser_names)
    expect(the_page.advisers.map(&:name)).to match_array(expected_adviser_names)
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
