RSpec.feature 'The dashboard trading name edit page' do
  include CheckboxGroupHelpers

  let(:firms_index_page) { Dashboard::FirmsIndexPage.new }
  let(:trading_name_edit_page) { Dashboard::TradingNameEditPage.new }
  let(:new_address) { 'Somewhere else' }

  scenario 'The principal can visit the edit page for the first trading name' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_a_firm_with_trading_names
    and_i_am_logged_in
    when_i_am_on_the_principal_dashboard_firms_page
    and_i_click_the_edit_link_for_the_first_trading_name
    then_i_see_the_edit_page_for_the_first_trading_name
    when_i_change_the_information
    and_i_click_save
    then_i_see_a_success_notice
    and_the_information_is_changed
  end

  scenario 'The system shows validation messages if there are invalid inputs' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_a_firm_with_trading_names
    and_i_am_logged_in
    when_i_am_on_the_principal_dashboard_firms_page
    and_i_click_the_edit_link_for_the_first_trading_name
    then_i_see_the_edit_page_for_the_first_trading_name
    when_i_invalidate_the_information
    and_i_click_save
    then_i_see_validation_messages
    and_the_information_is_not_changed
  end

  def given_i_am_a_fully_registered_principal_user
    @principal = FactoryGirl.create(:principal)
    @user = FactoryGirl.create(:user, principal: @principal)
  end

  def and_i_have_a_firm_with_trading_names
    firm_attrs = FactoryGirl.attributes_for(:firm_with_trading_names, fca_number: @principal.fca_number)
    @principal.firm.update_attributes(firm_attrs)
    @original_trading_name_email = @principal.firm.trading_names.first.email_address
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
    expect(trading_name_edit_page.firm_name).to have_text @principal.firm.trading_names[0].registered_name
  end

  def when_i_change_the_information
    trading_name_edit_page.address_line_one.set(new_address)
  end

  def when_i_invalidate_the_information
    trading_name_edit_page.email_address.set 'clearly_not_a_valid_email!'
  end

  def and_i_click_save
    trading_name_edit_page.save_button.click
  end

  def then_i_see_a_success_notice
    expect(trading_name_edit_page).to have_flash_message(text: I18n.t('dashboard.firm_edit.saved'))
  end

  def then_i_see_validation_messages
    expect(trading_name_edit_page).to have_validation_summary
  end

  def and_the_information_is_changed
    expect(trading_name_edit_page.address_line_one.value).to eq new_address

    @principal.reload
    expect(@principal.firm.trading_names.first.address_line_one).to eq new_address
  end

  def and_the_information_is_not_changed
    expect(trading_name_edit_page.email_address.value).to eq 'clearly_not_a_valid_email!'
    @principal.reload
    expect(@principal.firm.trading_names.first.email_address).to eq @original_trading_name_email
  end
end
