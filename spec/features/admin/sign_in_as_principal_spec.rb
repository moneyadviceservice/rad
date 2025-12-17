RSpec.feature 'Move advisers between firms' do
  let(:admin_firm_page) { Admin::TravelInsuranceFirmPage.new }
  let(:firms_index_page) { SelfService::TravelInsuranceFirms::IndexPage.new }

  scenario 'admin signs in as principal' do
    given_there_is_a_fully_registered_principal_user
    and_i_am_on_the_admin_firm_page
    when_i_sign_in_as_principal
    then_i_see "You are now signed in as #{@principal.full_name}"
    and_i_am_on_the_self_service_firm_page
  end

  def given_there_is_a_fully_registered_principal_user
    @principal = FactoryBot.create(:travel_insurance_firm_with_principal).principal
  end

  def and_i_am_on_the_admin_firm_page
    admin_firm_page.load(firm_id: @principal.travel_insurance_firm.id)
  end

  def when_i_sign_in_as_principal
    admin_firm_page.sign_in_as_principal.click
  end

  def then_i_see(message)
    expect(page.text).to include(message)
  end

  def and_i_am_on_the_self_service_firm_page
    expect(firms_index_page).to be_displayed
  end
end
