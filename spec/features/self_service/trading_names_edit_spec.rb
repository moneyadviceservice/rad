RSpec.feature 'The self service trading name edit page' do
  include CheckboxGroupHelpers

  let(:firms_index_page) { SelfService::FirmsIndexPage.new }
  let(:trading_name_edit_page) { SelfService::TradingNameEditPage.new }
  let(:website_address) { 'http://www.blahblah.com' }

  scenario 'The principal can visit the edit page for the first trading name' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_a_firm_with_trading_names
    and_i_am_logged_in
    when_i_am_on_the_firms_page
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
    when_i_am_on_the_firms_page
    and_i_click_the_edit_link_for_the_first_trading_name
    then_i_see_the_edit_page_for_the_first_trading_name
    when_i_invalidate_the_information
    and_i_click_save
    then_i_see_validation_messages
    and_the_information_is_not_changed
  end

  def given_i_am_a_fully_registered_principal_user
    @principal = FactoryBot.create(:principal)
    @user = FactoryBot.create(:user, principal: @principal)
  end

  def and_i_have_a_firm_with_trading_names
    firm_attrs = FactoryBot.attributes_for(:firm_with_trading_names, fca_number: @principal.fca_number)
    @principal.firm.update(firm_attrs)
    @original_website_address = trading_names(@principal).first.website_address
  end

  def and_i_am_logged_in
    login_as(@user, scope: :user)
  end

  def when_i_am_on_the_firms_page
    firms_index_page.load
    expect(firms_index_page).to be_displayed
  end

  def and_i_click_the_edit_link_for_the_first_trading_name
    firms_index_page.trading_names.first.edit_link.click
  end

  def then_i_see_the_edit_page_for_the_first_trading_name
    expect(trading_name_edit_page).to be_displayed
    expected_name = trading_names(@principal).first.registered_name
    expect(trading_name_edit_page.firm_name).to have_text expected_name
  end

  def when_i_change_the_information
    trading_name_edit_page.website_address.set(website_address)
  end

  def when_i_invalidate_the_information
    trading_name_edit_page.website_address.set 'clearly_not_a_valid_web_address!'
  end

  def and_i_click_save
    trading_name_edit_page.save_button.click
  end

  def then_i_see_a_success_notice
    expect(trading_name_edit_page).to have_flash_message(text: I18n.t('self_service.firm_edit.saved'))
  end

  def then_i_see_validation_messages
    expect(trading_name_edit_page).to have_validation_summary
  end

  def and_the_information_is_changed
    expect(trading_name_edit_page.website_address.value).to eq website_address

    @principal.reload
    expect(trading_names(@principal).first.website_address).to eq website_address
  end

  def and_the_information_is_not_changed
    expect(trading_name_edit_page.website_address.value).to eq 'clearly_not_a_valid_web_address!'
    @principal.reload
    expect(trading_names(@principal).first.website_address).to eq @original_website_address
  end

  private

  def trading_names(principal)
    principal.firm.trading_names.onboarded.sorted_by_registered_name
  end
end
