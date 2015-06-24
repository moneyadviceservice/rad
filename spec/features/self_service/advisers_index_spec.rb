RSpec.feature 'The self service adviser list page' do
  let(:advisers_index_page) { SelfService::AdvisersIndexPage.new }

  scenario 'The principal can see a list of the advisers on their parent firm' do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in
    and_i_have_a_firm_with_trading_names_and_advisers

    when_i_am_on_the_advisers_page_for(firm: @principal.firm)
    then_i_can_see_the_advisers_for(firm: @principal.firm)

    when_i_am_on_the_advisers_page_for(firm: @principal.firm.trading_names.first)
    then_i_can_see_the_advisers_for(firm: @principal.firm.trading_names.first)
  end

  scenario 'The principal has not added any advisers yet' do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in
    and_i_have_a_firm_with_trading_names_and_no_advisers

    when_i_am_on_the_advisers_page_for(firm: @principal.firm)
    then_there_is_a_prompt_to_add_an_adviser
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

  def when_i_am_on_the_advisers_page_for(firm:)
    advisers_index_page.load(firm_id: firm.id)
    expect(advisers_index_page).to be_displayed
  end

  def then_i_can_see_the_advisers_for(firm:)
    expect(advisers_index_page).to have_firm_name
    expect(advisers_index_page.firm_name).to have_text(firm.registered_name)
    expect(firm.advisers).not_to be_empty
    expect_table_to_match_advisers(advisers_index_page, firm.advisers)
  end

  def then_there_is_a_prompt_to_add_an_adviser
    expect(advisers_index_page).not_to have_advisers
    expect(advisers_index_page).to have_no_advisers_message(
      text: I18n.t('self_service.advisers_index.no_advisers_message'))
    expect(advisers_index_page).to have_add_adviser_link
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
