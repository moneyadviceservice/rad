RSpec.feature 'The self service firm offices list page', :inline_job_queue do
  include_context 'algolia index fake'

  let(:offices_index_page) { SelfService::OfficesIndexPage.new }
  let(:sign_in_page) { SignInPage.new }

  let(:principal) { FactoryBot.create(:principal) }
  let(:firm) { principal.firm }
  let(:user) { FactoryBot.create(:user, principal: principal) }
  let(:offices) { FactoryBot.create_list(:office, 3, officeable: firm) }

  scenario 'The page requires authentication to access' do
    when_i_navigate_to_the_offices_page_for_my_firm
    then_i_see(the_page: sign_in_page)
  end

  scenario 'We can get to the offices page for a given firm' do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in
    when_i_navigate_to_the_offices_page_for_my_firm
    then_i_see(the_page: offices_index_page)
    then_no_errors_are_displayed_on(the_page: offices_index_page)
    then_i_see_the_firm_name_in_the_page_title
  end

  scenario 'The principal can see a back to firms list link' do
    given_i_am_a_fully_registered_principal_user
    and_my_firm_has_offices
    and_i_am_logged_in
    when_i_navigate_to_the_offices_page_for_my_firm
    then_i_see_a_back_to_firms_list_link
  end

  scenario 'The page shows the overall status panel for the given firm' do
    given_i_am_a_fully_registered_principal_user
    and_my_firm_has_offices
    and_i_am_logged_in
    when_i_navigate_to_the_offices_page_for_my_firm
    then_i_can_see_the_overall_status_panel
  end

  scenario 'The page shows the list of offices for the given firm' do
    given_i_am_a_fully_registered_principal_user
    and_my_firm_has_offices
    and_i_am_logged_in
    when_i_navigate_to_the_offices_page_for_my_firm
    then_no_errors_are_displayed_on(the_page: offices_index_page)
    then_i_see_the_list_of_offices_associated_with_my_firm
    then_i_see_the_first_office_in_the_list_is_the_main_office
  end

  scenario 'The principal has not added any offices yet' do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in
    when_i_navigate_to_the_offices_page_for_my_firm
    then_there_is_a_prompt_to_add_an_office
  end

  scenario 'The principal can delete all offices except the main office' do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in
    and_my_firm_has_offices
    and_my_firm_has_and_adviser
    and_the_firm_offices_are_present_in_the_directory

    when_i_navigate_to_the_offices_page_for_my_firm
    then_no_errors_are_displayed_on(the_page: offices_index_page)
    then_i_see_delete_buttons_for_all_offices_except_the_main_firm

    when_i_delete_the_first_deletable_office
    then_i_see(the_page: offices_index_page)
    then_no_errors_are_displayed_on(the_page: offices_index_page)
    then_i_can_see_a_success_message
    then_there_is_one_less_office
    then_i_cannot_see_the_deleted_office
    and_the_deleted_office_gets_removed_from_the_directory
    and_the_total_number_of_firm_offices_in_the_directory_gets_decreased
  end

  def given_i_am_a_fully_registered_principal_user
    firm_attrs = FactoryBot.attributes_for(:firm, fca_number: principal.fca_number)
    firm.update(firm_attrs)
    expect(Firm.onboarded.find(firm.id)).to be_present
  end

  def and_my_firm_has_offices
    firm.update!(offices: offices)
  end

  def and_my_firm_has_and_adviser
    firm.update!(advisers: [FactoryBot.create(:adviser, firm: firm)])
  end

  def and_i_am_logged_in
    login_as(user, scope: :user)
  end

  def when_i_navigate_to_the_offices_page_for_my_firm
    offices_index_page.load(firm_id: firm.id)
  end

  def when_i_delete_the_first_deletable_office
    @num_offices_before = offices_index_page.offices.count
    @deleted_office_address = offices_index_page.offices.second.address.text
    @deleted_office_address_postcode = offices_index_page.offices.second.address_postcode.text
    offices_index_page.offices.second.delete_button.click
  end

  def then_i_see(the_page:)
    expect(the_page).to be_displayed
  end

  def then_no_errors_are_displayed_on(the_page:)
    expect(the_page).not_to have_text %r{[Ee]rror|[Ww]arn|[Ee]xception}
    expect(the_page.status_code).not_to eq(500)
  end

  def then_i_see_the_firm_name_in_the_page_title
    expect(offices_index_page.page_title).to have_text(firm.registered_name)
  end

  def then_i_see_the_list_of_offices_associated_with_my_firm
    expect(offices_index_page).to have_offices
    expect_table_to_match_offices(offices_index_page, firm.offices)
  end

  def then_i_see_the_first_office_in_the_list_is_the_main_office
    expect(offices_index_page.offices.first).to be_the_main_office
    expect(offices_index_page.offices.drop(1))
      .to rspec_all(have_attributes(the_main_office?: false))
  end

  def then_there_is_a_prompt_to_add_an_office
    expect(offices_index_page).not_to have_offices
    expect(offices_index_page).to have_no_offices_message(
      text: I18n.t('self_service.offices_index.no_offices_message'))
    expect(offices_index_page).to have_add_office_link
  end

  def then_i_see_delete_buttons_for_all_offices_except_the_main_firm
    expect(offices_index_page).to have_offices
    expect(offices_index_page.offices.first).not_to have_delete_button
    expect(offices_index_page.offices.drop(1)).to rspec_all(have_delete_button)
  end

  def then_i_can_see_a_success_message
    expect(offices_index_page).to have_flash_message
    expect(offices_index_page.flash_message).to have_text(@deleted_office_address_postcode)
  end

  def then_i_cannot_see_the_deleted_office
    addresses = offices_index_page.offices.map { |office| office.address.text }
    expect(addresses).not_to include(@deleted_office_address)
  end

  def then_there_is_one_less_office
    expect(offices_index_page.offices.count).to eq(@num_offices_before - 1)
  end

  def and_the_firm_offices_are_present_in_the_directory
    @original_firm_total_offices_in_dir =
      firm_total_offices_in_directory(firm)
    @original_firm_offices_in_dir = firm_offices_in_directory(firm)

    firm_total_offices = firm.offices.size
    expect(@original_firm_offices_in_dir.size)
      .to eq firm_total_offices
    expect(@original_firm_total_offices_in_dir)
      .to eq firm_total_offices
  end

  def and_the_deleted_office_gets_removed_from_the_directory
    expect(firm_offices_in_directory(firm).size)
      .to eq(@original_firm_offices_in_dir.size - 1)
  end

  def and_the_total_number_of_firm_offices_in_the_directory_gets_decreased
    expect(firm_total_offices_in_directory(firm))
      .to eq(@original_firm_total_offices_in_dir - 1)
  end

  def then_i_see_a_back_to_firms_list_link
    expect(offices_index_page).to have_back_to_firms_list_link
  end

  def then_i_can_see_the_overall_status_panel
    expect(offices_index_page).to have_overall_status_panel
  end

  private

  def expect_table_to_match_offices(table, offices)
    offices.each.with_index do |office, office_index|
      expect_section_to_match_record(table.offices[office_index], office)
    end
  end

  def expect_section_to_match_record(section, record)
    expect(section.address).to have_text(record.address_line_one)
    expect(section.address_postcode).to have_text(record.address_postcode)
    expect(section.telephone_number).to have_text(record.telephone_number)
    expect(section.email_address).to have_text(record.email_address)
    expect(section.disabled_access).to have_text(%r{Yes|No})
  end
end
