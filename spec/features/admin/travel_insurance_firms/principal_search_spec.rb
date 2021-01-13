RSpec.describe 'Travel insurance principals' do
  let(:the_page) { Admin::TravelInsurancePrincipalsIndexPage.new }

  before do
    given_there_are_principals
    given_i_am_on_the_admin_travel_insurance_principal_index_page
    then_i_see_all_principals
  end

  scenario 'Filtering by FCA number' do
    when_i_filter_by fca_number: '123456'
    then_i_see_n_results(1)

    when_i_clear_all_filters
    then_i_see_all_principals
  end

  scenario 'Filtering by firm name' do
    when_i_filter_by registered_name: 'Acme Finance'
    then_i_see_n_results(1)
    then_i_only_see_principal_with registered_name: 'Acme Finance'

    when_i_clear_all_filters
    then_i_see_all_principals
  end

  def given_i_am_on_the_admin_travel_insurance_principal_index_page
    the_page.load
  end

  def given_there_are_principals
    @principals = [
      FactoryBot.create(
        :principal,
        travel_insurance_firm: FactoryBot.build(
          :travel_insurance_firm,
          registered_name: 'Acme Finance'
        )
      ),
      FactoryBot.create(
        :principal,
        fca_number: '123456',
        travel_insurance_firm: FactoryBot.build(
          :travel_insurance_firm,
          fca_number: '123456'
        )
      )
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
    expect(the_page.total_principals).to eq(expected_count)
  end

  def then_i_only_see_principals_with(expected_common_attrs)
    expect(the_page.principals).to rspec_all(have_attributes(expected_common_attrs))
  end

  def then_i_see_all_principals
    expect(the_page.total_principals).to eq(@principals.count)
    expect(the_page.principals.count).to eq(@principals.count)
  end

  def then_i_only_see_principal_with(expected_common_attrs)
    expect(the_page.principals).to rspec_all(have_attributes(expected_common_attrs))
  end

  def submit_the_form
    the_page.submit.click
    expect_no_errors
  end

  def expect_no_errors
    return unless the_page.status_code == 500

    expect(the_page).not_to have_text %r{[Ee]rror|[Ww]arn|[Ee]xception}
  end
end
