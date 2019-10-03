RSpec.feature 'Searching for firms on the admin interface' do
  let(:the_page) { Admin::FirmsIndexPage.new }
  let(:example_language) { Languages::AVAILABLE_LANGUAGES[0].iso_639_3 }

  before do
    given_there_are_firms
    given_i_am_on_the_admin_firms_index_page
    then_i_see_all_firms
  end

  scenario 'Filtering by FCA number' do
    when_i_filter_by fca_number: '123456'
    then_i_see_n_results(2)
    then_i_only_see_firms_with fca_number: '123456'

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

  scenario 'Filtering by ethical & sharia investing services' do
    when_i_filter_by ethical_investing_flag: true
    then_i_see_n_results(2)
    then_i_only_see_firms 'Ethical & sharia', 'Only ethical'

    when_i_filter_by sharia_investing_flag: true
    then_i_see_n_results(2)
    then_i_only_see_firms 'Ethical & sharia', 'Only sharia'

    when_i_filter_by ethical_investing_flag: true, sharia_investing_flag: true
    then_i_see_n_results(1)
    then_i_only_see_firms 'Ethical & sharia'

    when_i_clear_all_filters
    then_i_see_all_firms
  end

  scenario 'Filtering for firms that have selected languages' do
    when_i_filter_by languages: true
    then_i_see_n_results(2)
    then_i_only_see_firms_with fca_number: '234567'

    when_i_filter_by languages: true, registered_name: 'With languages 1'
    then_i_see_n_results(1)
    then_i_only_see_firms_with registered_name: 'With languages 1', fca_number: '234567'

    when_i_clear_all_filters
    then_i_see_all_firms
  end

  scenario 'Filtering for firms that offer Workplace Financial Advice' do
    when_i_filter_by workplace_financial_advice_flag: true
    then_i_see_n_results(1)
    then_i_only_see_firms_with registered_name: 'Acme Finance'

    when_i_clear_all_filters
    then_i_see_all_firms
  end

  def given_i_am_on_the_admin_firms_index_page
    the_page.load
    expect(the_page).to be_displayed
    expect_no_errors
  end

  def given_there_are_firms
    @firms = [
      FactoryBot.create(:firm, registered_name: 'Acme Finance', workplace_financial_advice_flag: true),
      FactoryBot.create(:firm, fca_number: '123456'),
      FactoryBot.create(:firm, fca_number: '123456'),

      FactoryBot.create(:firm, registered_name: 'Ethical & sharia',
                                ethical_investing_flag: true, sharia_investing_flag: true),
      FactoryBot.create(:firm, registered_name: 'Only ethical',
                                ethical_investing_flag: true, sharia_investing_flag: false),
      FactoryBot.create(:firm, registered_name: 'Only sharia',
                                ethical_investing_flag: false, sharia_investing_flag: true),

      FactoryBot.create(:firm, registered_name: 'With languages 1',
                                fca_number: '234567', languages: [example_language]),
      FactoryBot.create(:firm, registered_name: 'With languages 2',
                                fca_number: '234567', languages: [example_language])
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
