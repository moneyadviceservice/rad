RSpec.feature 'The dashboard adviser list page' do
  let(:advisers_index_page) { Dashboard::AdvisersIndexPage.new }

  scenario 'The principal can see a list of the advisers on their parent firm' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_a_firm_with_trading_names_and_advisers
    and_i_am_logged_in
    when_i_am_on_the_principal_dashboard_advisers_page
    then_i_can_see_the_advisers_for_the_parent_firm
    then_i_can_see_the_advisers_for_each_trading_name
  end

  scenario 'The principal has not added any advisers yet' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_a_firm_with_trading_names_and_no_advisers
    and_i_am_logged_in
    when_i_am_on_the_principal_dashboard_advisers_page
    then_the_parent_firm_section_shows_a_prompt_to_add_an_adviser
    then_each_trading_name_section_shows_a_prompt_to_add_an_adviser
  end

  def given_i_am_a_fully_registered_principal_user
    @principal = FactoryGirl.create(:principal)
    @user = FactoryGirl.create(:user, principal: @principal)
  end

  def and_i_have_a_firm_with_trading_names_and_no_advisers
    firm_attrs = FactoryGirl.attributes_for(:firm_with_trading_names, fca_number: @principal.fca_number)
    @principal.firm.update_attributes(firm_attrs)
  end

  def and_i_have_a_firm_with_trading_names_and_advisers
    and_i_have_a_firm_with_trading_names_and_no_advisers

    @principal.firm.update(advisers: FactoryGirl.create_list(:adviser, 3))
    @principal.firm.trading_names.each do |trading_name|
      trading_name.update(advisers: FactoryGirl.create_list(:adviser, 3))
    end
  end

  def and_i_am_logged_in
    login_as(@user, scope: :user)
  end

  def when_i_am_on_the_principal_dashboard_advisers_page
    advisers_index_page.load
    expect(advisers_index_page).to be_displayed
  end

  def then_i_can_see_the_advisers_for_the_parent_firm
    expect_table_to_match_advisers(advisers_index_page.parent_firm, @principal.firm.advisers)
  end

  def then_i_can_see_the_advisers_for_each_trading_name
    @principal.firm.trading_names.each.with_index do |trading_name, index|
      trading_name_table = advisers_index_page.trading_names[index]
      expect_table_to_match_advisers(trading_name_table, trading_name.advisers)
    end
  end

  def then_the_parent_firm_section_shows_a_prompt_to_add_an_adviser
    expect(advisers_index_page).to have_parent_firm
    expect(advisers_index_page.parent_firm).to have_no_advisers_message(
      text: I18n.t('dashboard.advisers_index.no_advisers_message'))
    expect(advisers_index_page.parent_firm).to have_add_adviser_link
  end

  def then_each_trading_name_section_shows_a_prompt_to_add_an_adviser
    expect(advisers_index_page).to have_trading_names(
      count: @principal.firm.trading_names.count)

    advisers_index_page.trading_names.each do |trading_name_section|
      expect(trading_name_section).to have_no_advisers_message(
        text: I18n.t('dashboard.advisers_index.no_advisers_message'))
      expect(trading_name_section).to have_add_adviser_link
    end
  end

  private

  def expect_table_to_match_advisers(table, advisers)
    advisers.each.with_index do |adviser, adviser_index|
      expect_section_to_match_record(table.advisers[adviser_index], adviser)
    end
  end

  def expect_section_to_match_record(section, record)
    expect(section).to have_reference_number(text: record.reference_number)
    expect(section).to have_name(text: record.name)
    expect(section).to have_postcode(text: record.postcode)
  end
end
