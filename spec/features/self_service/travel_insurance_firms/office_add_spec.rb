 RSpec.feature 'The travel insurance self service office add page', :inline_job_queue do
  include_context 'algolia index fake'

  let(:travel_insurance_index_page) { SelfService::TravelInsuranceFirms::IndexPage.new }
  let(:office_add_page) { SelfService::TravelInsuranceFirms::OfficeAddPage.new }

  let(:address_line_one) { '120 Holborn' }
  let(:address_line_two) { 'Floor 5' }
  let(:address_town)     { 'London' }
  let(:address_postcode) { 'EC1N 2TD' }

  let!(:principal) { FactoryBot.create(:principal) }
  let!(:firm) { FactoryBot.create(:travel_insurance_firm, principal: principal) }
  let(:user) { FactoryBot.create(:user, principal: principal) }
  let(:office) do
    FactoryBot.attributes_for(:office,
                               officeable: firm,
                               address_line_one: address_line_one,
                               address_line_two: address_line_two,
                               address_town: address_town,
                               address_county: '',
                               address_postcode: address_postcode,
                               add_opening_time: true)
  end

  scenario 'The principal adds office details' do
    given_i_am_a_fully_registered_principal_user
    and_the_principal_firm_has_no_office
    and_i_am_logged_in

    when_i_am_on_the_offices_page
    then_no_errors_are_displayed_on(the_page: travel_insurance_index_page)

    when_i_go_to_create_a_new_office
    the_i_see(the_page: office_add_page)
    then_no_errors_are_displayed_on(the_page: office_add_page)

    when_i_fill_out_the_form
    and_i_click_save
    the_i_see(the_page: travel_insurance_index_page)
    then_no_errors_are_displayed_on(the_page: travel_insurance_index_page)
    then_i_see_a_success_notice
    then_the_new_office_is_saved
    and_the_total_number_of_firm_offices_in_the_directory_gets_increased
  end

  scenario 'The system shows validation messages if there are invalid inputs' do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in

    when_i_am_on_the_offices_page
    then_no_errors_are_displayed_on(the_page: travel_insurance_index_page)

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
    principal.firm.update_attributes(firm_attrs)
    expect(Firm.onboarded.find(principal.firm.id)).to be_present
  end

  def and_i_am_logged_in
    login_as(user, scope: :user)
  end

  def when_i_am_on_the_offices_page
    travel_insurance_index_page.load(firm_id: principal.firm.id)
    expect(travel_insurance_index_page).to be_displayed
  end

  def when_i_go_to_create_a_new_office
    travel_insurance_index_page.add_office_link.click
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
    ].each do |field_name|
      office_add_page.send(field_name).set(office[field_name])
    end

    office_add_page.select("02 AM", from: "office_opening_time_attributes_weekday_opening_time_4i")
    office_add_page.select("05", from: "office_opening_time_attributes_weekday_opening_time_5i")
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

  def then_the_new_office_is_saved
    firm.reload
    expect(firm.office).to be_present
    expect(firm.office.address_line_one).to have_text(office[:address_line_one])
    expect(firm.office.address_postcode).to have_text(office[:address_postcode])
  end

  def and_the_principal_firm_has_no_office
    expect(firm.office).to be_nil
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
