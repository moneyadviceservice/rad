RSpec.feature 'The self service firm offices list page' do
  let(:offices_index_page) { SelfService::OfficesIndexPage.new }
  let(:sign_in_page) { SignInPage.new }

  let(:principal) { FactoryGirl.create(:principal) }
  let(:user) { FactoryGirl.create(:user, principal: principal) }
  let(:offices) { FactoryGirl.create_list(:office, 3, firm: principal.firm) }

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

  scenario 'The page shows the list of offices for the given firm' do
    given_i_am_a_fully_registered_principal_user
    and_my_firm_has_offices
    and_i_am_logged_in
    when_i_navigate_to_the_offices_page_for_my_firm
    then_no_errors_are_displayed_on(the_page: offices_index_page)
    then_i_see_the_list_of_offices_associated_with_my_firm
  end

  def given_i_am_a_fully_registered_principal_user
    firm_attrs = FactoryGirl.attributes_for(:firm, fca_number: principal.fca_number)
    principal.firm.update_attributes(firm_attrs)
    expect(Firm.registered.find(principal.firm.id)).to be_present
  end

  def and_my_firm_has_offices
    principal.firm.update!(offices: offices)
  end

  def and_i_am_logged_in
    login_as(user, scope: :user)
  end

  def when_i_navigate_to_the_offices_page_for_my_firm
    offices_index_page.load(firm_id: principal.firm.id)
  end

  def then_i_see(the_page:)
    expect(the_page).to be_displayed
  end

  def then_no_errors_are_displayed_on(the_page:)
    expect(the_page).not_to have_text %r{[Ee]rror|[Ww]arn|[Ee]xception}
    expect(the_page.status_code).not_to eq(500)
  end

  def then_i_see_the_firm_name_in_the_page_title
    expect(offices_index_page.page_title).to have_text(principal.firm.registered_name)
  end

  def then_i_see_the_list_of_offices_associated_with_my_firm
    expect(offices_index_page.offices).not_to be_empty
    expect_table_to_match_offices(offices_index_page, principal.firm.offices)
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
