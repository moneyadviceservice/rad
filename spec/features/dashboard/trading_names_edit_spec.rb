RSpec.feature 'The dashboard trading name edit page' do
  include CheckboxGroupHelpers

  let(:firms_index_page) { Dashboard::FirmsIndexPage.new }
  let(:trading_name_edit_page) { Dashboard::TradingNameEditPage.new }

  scenario 'The principal can visit the edit page for the first trading name' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_a_firm_with_trading_names
    and_i_am_logged_in
    when_i_am_on_the_principal_dashboard_firms_page
    and_i_click_the_edit_link_for_the_first_trading_name
    then_i_see_the_edit_page_for_the_first_trading_name
  end

  def given_i_am_a_fully_registered_principal_user
    @principal = FactoryGirl.create(:principal)
    @user = FactoryGirl.create(:user, principal: @principal)
  end

  def and_i_have_a_firm_with_trading_names
    firm_attrs = FactoryGirl.attributes_for(:firm_with_trading_names, fca_number: @principal.fca_number)
    @principal.firm.update_attributes(firm_attrs)
    @original_firm_email = @principal.firm.email_address
  end

  def and_i_am_logged_in
    login_as(@user, scope: :user)
  end

  def when_i_am_on_the_principal_dashboard_firms_page
    firms_index_page.load
    expect(firms_index_page).to be_displayed
  end

  def and_i_click_the_edit_link_for_the_first_trading_name
    firms_index_page.trading_names.first.edit_link.click
  end

  def then_i_see_the_edit_page_for_the_first_trading_name
    expect(trading_name_edit_page).to be_displayed
    expect(trading_name_edit_page.firm_name).to have_text @principal.firm.trading_names.first.registered_name
  end
end
