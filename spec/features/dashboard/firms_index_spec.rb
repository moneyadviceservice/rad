RSpec.feature 'The dashboard firm list page' do
  let(:firms_index_page) { Dashboard::FirmsIndexPage.new }

  scenario 'When there are both available and added trading names' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_a_firm_with_both_available_and_added_trading_names
    and_i_am_logged_in
    when_i_am_on_the_principal_dashboard_firms_page
    then_i_can_see_the_parent_firm_i_am_associated_with
    and_i_can_see_the_list_of_trading_names_i_am_associated_with
    and_i_can_see_the_list_of_available_trading_names
  end

  scenario 'When there are no added or available trading names' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_a_firm_with_no_available_or_added_trading_names
    and_i_am_logged_in
    when_i_am_on_the_principal_dashboard_firms_page
    then_i_can_see_the_parent_firm_i_am_associated_with
    and_the_trading_names_block_is_not_shown
    and_the_available_trading_names_block_is_not_shown
  end

  scenario 'When there are available trading names but none have been added' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_a_firm_with_available_trading_names_but_none_added
    and_i_am_logged_in
    when_i_am_on_the_principal_dashboard_firms_page
    then_i_can_see_the_parent_firm_i_am_associated_with
    and_the_trading_names_section_is_showing_a_prompt_to_add_a_trading_name
    and_i_can_see_the_list_of_available_trading_names
  end

  def given_i_am_a_fully_registered_principal_user
    @principal = FactoryGirl.create(:principal)
    @user = FactoryGirl.create(:user, principal: @principal)
    firm_attrs = FactoryGirl.attributes_for(:firm,
                                            fca_number: @principal.fca_number,
                                            registered_name: @principal.lookup_firm.registered_name)
    @principal.firm.update_attributes(firm_attrs)
  end

  def and_i_have_a_firm_with_both_available_and_added_trading_names
    @lookup_trading_name = FactoryGirl.create(:lookup_subsidiary, fca_number: @principal.fca_number)
    @principal.firm.trading_names = create_list(:trading_name,
                                                3,
                                                fca_number: @principal.fca_number)
    expect(@principal.firm.trading_names).to have(3).items
    expect(@principal.lookup_firm.subsidiaries).to have(1).item
  end

  def and_i_have_a_firm_with_no_available_or_added_trading_names
    expect(@principal.firm.trading_names).to be_empty
    expect(@principal.lookup_firm.subsidiaries).to be_empty
  end

  def and_i_have_a_firm_with_available_trading_names_but_none_added
    @lookup_trading_name = FactoryGirl.create(:lookup_subsidiary, fca_number: @principal.fca_number)
    expect(@principal.lookup_firm.subsidiaries).to have(1).item
    expect(@principal.firm.trading_names).to be_empty
  end

  def and_i_am_logged_in
    login_as(@user, scope: :user)
  end

  def when_i_am_on_the_principal_dashboard_firms_page
    firms_index_page.load
    expect(firms_index_page).to be_displayed
  end

  def then_i_can_see_the_parent_firm_i_am_associated_with
    expect(firms_index_page).to have_parent_firm
    expect_firm_table_row(firms_index_page.parent_firm, @principal.firm)
  end

  def and_i_can_see_the_list_of_trading_names_i_am_associated_with
    expect(firms_index_page).to have_trading_names_block

    trading_names = @principal.firm.trading_names.sorted_by_registered_name
    firms_index_page.trading_names.zip(trading_names).each do |trading_name_section, trading_name|
      expect_firm_table_row(trading_name_section, trading_name)
    end
  end

  def and_i_can_see_the_list_of_available_trading_names
    expect(firms_index_page).to have_available_trading_names_block
    expect(firms_index_page.available_trading_names.size).to eq 1
    expect(firms_index_page.available_trading_names.first).to have_name(text: @lookup_trading_name.name)
  end

  def and_the_trading_names_block_is_not_shown
    expect(firms_index_page).not_to have_trading_names_block
  end

  def and_the_available_trading_names_block_is_not_shown
    expect(firms_index_page).not_to have_available_trading_names_block
  end

  def and_the_trading_names_section_is_showing_a_prompt_to_add_a_trading_name
    expect(firms_index_page).to have_trading_names_block
    expect(firms_index_page).to have_add_trading_names_prompt(
      text: I18n.t('dashboard.firms_index.add_trading_names_prompt'))
    expect(firms_index_page).not_to have_trading_names
  end

  private

  def expect_firm_table_row(firm_row, firm)
    expect(firm_row).to have_frn(text: firm.fca_number)
    expect(firm_row).to have_name(text: firm.registered_name)
    expect(firm_row).to have_principal_name(text: firm.principal.full_name)
  end
end
