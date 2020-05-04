RSpec.feature 'The self service adviser list page', :inline_job_queue do
  include_context 'algolia index fake'

  let(:advisers_index_page) { SelfService::AdvisersIndexPage.new }

  scenario 'The principal can see a back to firms list link' do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in
    and_i_have_a_firm_with_trading_names_and_advisers

    when_i_am_on_the_advisers_page_for(firm: @principal.firm)
    then_i_see_a_back_to_firms_list_link

    when_i_am_on_the_advisers_page_for(firm: @principal.firm.trading_names.first)
    then_i_see_a_back_to_firms_list_link
  end

  scenario 'The principal can see the overall status panel for the firm' do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in
    and_i_have_a_firm_with_trading_names_and_advisers

    when_i_am_on_the_advisers_page_for(firm: @principal.firm)
    then_i_can_see_the_overall_status_panel

    when_i_am_on_the_advisers_page_for(firm: @principal.firm.trading_names.first)
    then_i_can_see_the_overall_status_panel
  end

  scenario 'The principal can see a list of the advisers on their parent firm' do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in
    and_i_have_a_firm_with_trading_names_and_advisers

    when_i_am_on_the_advisers_page_for(firm: @principal.firm)
    then_i_can_see_the_advisers_for(firm: @principal.firm)

    when_i_am_on_the_advisers_page_for(firm: @principal.firm.trading_names.first)
    then_i_can_see_the_advisers_for(firm: @principal.firm.trading_names.first)
  end

  scenario 'The principal can delete advisers' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_a_firm_with_trading_names_and_advisers
    and_the_firm_advisers_are_present_in_the_directory
    and_i_am_logged_in
    and_i_am_on_the_advisers_page_for(firm: @principal.firm)
    when_i_delete_the_first_adviser
    then_i_am_on_the_advisers_page_for(firm: @principal.firm)
    and_i_can_see_a_success_message
    and_i_cannot_see_the_deleted_adviser
    and_the_deleted_adviser_gets_removed_from_the_directory
  end

  def when_i_delete_the_first_adviser
    @adviser_name = advisers_index_page.advisers.first.name.text
    @deleted_adviser = Adviser.find_by(name: @adviser_name)
    advisers_index_page.advisers.first.delete_link.click
  end

  def then_i_am_on_the_advisers_page_for(firm:)
    expect(advisers_index_page).to be_displayed
    expect(advisers_index_page).to have_firm_name(text: firm.registered_name)
  end

  def and_i_can_see_a_success_message
    expected_message = "#{@adviser_name} has been successfully removed."
    expect(advisers_index_page).to have_flash_message(text: expected_message)
  end

  def and_i_cannot_see_the_deleted_adviser
    advisers = advisers_index_page.advisers
    expect(advisers.any? { |a| a.name == @adviser_name }).to be_falsey
  end

  def and_the_firm_advisers_are_present_in_the_directory
    @original_firm_advisers_in_dir = firm_advisers_in_directory(@principal.firm)
    expect(@original_firm_advisers_in_dir.size)
      .to eq @principal.firm.advisers.size
  end

  def and_the_deleted_adviser_gets_removed_from_the_directory
    expect(firm_advisers_in_directory(@principal.firm).size)
      .to eq(@original_firm_advisers_in_dir.size - 1)
  end

  scenario 'The principal has not added any advisers yet' do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in
    and_i_have_a_firm_with_trading_names_and_no_advisers

    when_i_am_on_the_advisers_page_for(firm: @principal.firm)
    then_there_is_a_prompt_to_add_an_adviser
  end

  def given_i_am_a_fully_registered_principal_user
    @principal = FactoryBot.create(:principal)
    @user = FactoryBot.create(:user, principal: @principal)
  end

  def and_i_have_a_firm_with_trading_names_and_no_advisers
    firm_attrs = FactoryBot.attributes_for(:firm_with_trading_names, fca_number: @principal.fca_number)
    @principal.firm.update(firm_attrs)
  end

  def and_i_have_a_firm_with_trading_names_and_advisers
    and_i_have_a_firm_with_trading_names_and_no_advisers

    @principal.firm.update(advisers: FactoryBot.create_list(:advisers_retirement_firm, 3))
    @principal.firm.trading_names.each do |trading_name|
      trading_name.update(advisers: FactoryBot.create_list(:advisers_retirement_firm, 3))
    end
  end

  def and_i_am_logged_in
    login_as(@user, scope: :user)
  end

  def when_i_am_on_the_advisers_page_for(firm:)
    advisers_index_page.load(firm_id: firm.id)
    expect(advisers_index_page).to be_displayed
  end

  alias_method :and_i_am_on_the_advisers_page_for, :when_i_am_on_the_advisers_page_for

  def then_i_can_see_the_advisers_for(firm:)
    expect(advisers_index_page).to have_firm_name
    expect(advisers_index_page.firm_name).to have_text(firm.registered_name)
    expect(firm.advisers).not_to be_empty
    expect_table_to_match_advisers(advisers_index_page, firm.advisers.sorted_by_name)
  end

  def then_there_is_a_prompt_to_add_an_adviser
    expect(advisers_index_page).not_to have_advisers
    expect(advisers_index_page).to have_no_advisers_message(
      text: I18n.t('self_service.advisers_index.no_advisers_message')
    )
    expect(advisers_index_page).to have_add_adviser_link
  end

  def then_i_see_a_back_to_firms_list_link
    expect(advisers_index_page).to have_back_to_firms_list_link
  end

  def then_i_can_see_the_overall_status_panel
    expect(advisers_index_page).to have_overall_status_panel
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
