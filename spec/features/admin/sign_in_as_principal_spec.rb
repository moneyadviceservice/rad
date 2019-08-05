RSpec.feature 'Move advisers between firms' do
  let(:admin_firm_page) { Admin::FirmPage.new }
  let(:firms_index_page) { SelfService::FirmsIndexPage.new }
  let(:updated_postcode) { 'EH11 2AB' }

  scenario 'admin signs in as principal' do
    given_there_is_a_fully_registered_principal_user
    and_i_am_on_the_admin_firm_page
    when_i_sign_in_as_principal
    then_i_see "You are now signed in as #{@principal.full_name}"
    and_i_am_on_the_self_service_firm_page
  end

  scenario 'admin visits page of firm with a principal without a user record' do
    # i.e. when the invite rake task hasn't been run
    given_there_is_a_principal
    and_i_am_on_the_admin_firm_page
    then_it_doesnt_blow_up
  end

  def given_there_is_a_fully_registered_principal_user
    @user = FactoryGirl.create(:user)
    @principal = @user.principal
    @principal.firm = FactoryGirl.create(:firm)
  end

  def and_i_am_on_the_admin_firm_page
    admin_firm_page.load(firm_id: @principal.firm.id)
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

  def given_there_is_a_principal
    @principal = FactoryGirl.create(:principal)
    @principal.firm = FactoryGirl.create(:firm)
  end

  def then_it_doesnt_blow_up
    expect(admin_firm_page).to_not have_text('NoMethodError')
  end
end
