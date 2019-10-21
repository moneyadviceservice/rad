RSpec.feature 'Self service add trading name' do
  let(:firms_index_page) { SelfService::FirmsIndexPage.new }

  scenario 'Adding a trading name from the firms index page' do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in
    and_my_firm_has_subsidiaries
    and_offers_other_advice_methods
    when_i_am_on_the_firms_page
    and_i_add_a_subsidiary_to_the_directory
    then_i_see_a_success_notice
  end

  private

  def given_i_am_a_fully_registered_principal_user
    @user =
      FactoryBot.create(
        :user,
        principal: FactoryBot.create(:principal, firm: FactoryBot.create(:firm))
      )
    @principal = @user.principal
    @firm = @principal.firm
  end

  def and_i_am_logged_in
    sign_in(@user)
  end

  def and_my_firm_has_subsidiaries
    FactoryBot.create(
      :lookup_subsidiary,
      fca_number: @firm.fca_number
    )
  end

  def and_offers_other_advice_methods
    @firm.other_advice_methods = [FactoryBot.create(:other_advice_method)]
  end

  def when_i_am_on_the_firms_page
    firms_index_page.load
    expect(firms_index_page).to be_displayed
  end

  def and_i_add_a_subsidiary_to_the_directory
    expect(firms_index_page.available_trading_names.first).to be_present
    firms_index_page.available_trading_names.first.edit_link.click

    complete_trading_name_form

    page.click_button('Save', match: :first)
  end

  def complete_trading_name_form
    page.choose('firm_primary_advice_method_remote')
    page.choose('firm_free_initial_meeting_false')
    page.check('firm[other_advice_method_ids][]', match: :first)
    page.check('firm[initial_advice_fee_structure_ids][]', match: :first)
    page.check('firm[ongoing_advice_fee_structure_ids][]', match: :first)
    page.check('firm[allowed_payment_method_ids][]', match: :first)
    page.check('firm[investment_size_ids][]', match: :first)
    page.check('firm_long_term_care_flag')
  end

  def then_i_see_a_success_notice
    expect(firms_index_page).to have_flash_message(
      text: I18n.t('self_service.trading_name_edit.saved')
    )
  end
end
