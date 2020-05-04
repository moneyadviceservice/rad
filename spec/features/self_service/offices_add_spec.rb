RSpec.feature 'The self service office add page', :inline_job_queue do
  include_context 'algolia index fake'

  let(:offices_index_page) { SelfService::OfficesIndexPage.new }
  let(:office_add_page) { SelfService::OfficeAddPage.new }
  let(:office_edit_page) { SelfService::OfficeEditPage.new }

  let(:address_line_one) { '120 Holborn' }
  let(:address_line_two) { 'Floor 5' }
  let(:address_town)     { 'London' }
  let(:address_postcode) { 'EC1N 2TD' }

  let(:principal) { FactoryBot.create(:principal) }
  let(:firm) { principal.firm }
  let(:user) { FactoryBot.create(:user, principal: principal) }
  let(:office) do
    FactoryBot.attributes_for(:office,
                               address_line_one: address_line_one,
                               address_line_two: address_line_two,
                               address_town: address_town,
                               address_county: '',
                               address_postcode: address_postcode)
  end

  scenario 'The principal can create a new office' do
    given_i_am_a_fully_registered_principal_user
    and_the_principal_firm_has_an_adviser_but_no_office
    and_i_am_logged_in

    when_i_am_on_the_offices_page
    then_no_errors_are_displayed_on(the_page: offices_index_page)

    when_i_go_to_create_a_new_office
    the_i_see(the_page: office_add_page)
    then_no_errors_are_displayed_on(the_page: office_add_page)

    when_i_fill_out_the_form
    and_i_click_save
    the_i_see(the_page: offices_index_page)
    then_no_errors_are_displayed_on(the_page: offices_index_page)
    then_i_see_a_success_notice
    then_the_new_office_is_listed
    and_the_new_office_is_present_in_the_directory
    and_the_total_number_of_firm_offices_in_the_directory_gets_increased
  end

  scenario 'The system shows validation messages if there are invalid inputs' do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in

    when_i_am_on_the_offices_page
    then_no_errors_are_displayed_on(the_page: offices_index_page)

    when_i_go_to_create_a_new_office
    the_i_see(the_page: office_add_page)
    then_no_errors_are_displayed_on(the_page: office_add_page)

    when_i_fill_out_the_form
    and_i_invalidate_the_information
    and_i_click_save
    then_i_see_validation_messages
    then_the_information_is_not_changed
  end

  def given_i_am_a_fully_registered_principal_user
    firm_attrs = FactoryBot.attributes_for(:firm, fca_number: principal.fca_number)
    principal.firm.update(firm_attrs)
    expect(Firm.onboarded.find(principal.firm.id)).to be_present
  end

  def and_i_am_logged_in
    login_as(user, scope: :user)
  end

  def when_i_am_on_the_offices_page
    offices_index_page.load(firm_id: principal.firm.id)
    expect(offices_index_page).to be_displayed
  end

  def when_i_go_to_create_a_new_office
    offices_index_page.add_office_link.click
  end

  def then_no_errors_are_displayed_on(the_page:)
    # Matching only on title-case 'Error' as the word 'error' appears in the
    # validation message preamble
    expect(the_page).not_to have_text %r{Error|[Ww]arn|[Ee]xception}
    expect(the_page.status_code).not_to eq(500)
  end

  def the_i_see(the_page:)
    expect(the_page).to be_displayed
  end

  def when_i_fill_out_the_form
    [
      :address_line_one,
      :address_line_two,
      :address_town,
      :address_county,
      :address_postcode,
      :email_address,
      :telephone_number,
      :disabled_access
    ].each do |field_name|
      office_add_page.send(field_name).set(office[field_name])
    end
  end

  def and_i_invalidate_the_information
    office_add_page.address_postcode.set 'clearly_not_a_valid_postcode'
  end

  def and_i_click_save
    office_add_page.save_button.click
  end

  def then_i_see_a_success_notice
    expect(office_add_page).to have_flash_message(text: I18n.t('self_service.office_add.saved'))
  end

  def then_the_new_office_is_listed
    expect(offices_index_page.offices.count).to be(1)
    expect(offices_index_page.offices.first.address).to have_text(office[:address_line_one])
    expect(offices_index_page.offices.first.address_postcode).to have_text(office[:address_postcode])
  end

  def and_the_principal_firm_has_an_adviser_but_no_office
    firm.update!(advisers: [FactoryBot.create(:advisers_retirement_firm, firm: firm)])
    expect(firm_advisers_in_directory(firm).size).to eq 1
    expect(firm_total_advisers_in_directory(firm)).to eq 1
    expect(firm_offices_in_directory(firm).size).to eq 0
    expect(firm_total_offices_in_directory(firm)).to eq 0
  end

  def and_the_new_office_is_present_in_the_directory
    expect(firm_offices_in_directory(firm).size).to eq 1

    directory_office = firm_offices_in_directory(firm).first
    expect(directory_office['address_postcode']).to eq office[:address_postcode]
    expect(directory_office['address_line_one']).to eq office[:address_line_one]
    expect(directory_office['address_line_two']).to eq office[:address_line_two]
    expect(directory_office['address_town']).to eq office[:address_town]
  end

  def and_the_total_number_of_firm_offices_in_the_directory_gets_increased
    expect(firm_total_offices_in_directory(firm)).to eq 1
  end

  def then_i_see_validation_messages
    expect(office_add_page).to have_validation_summary
  end

  def then_the_information_is_not_changed
    expect(office_add_page.address_postcode.value).to eq 'clearly_not_a_valid_postcode'
  end
end
