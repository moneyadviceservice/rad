RSpec.feature 'The self service office edit page', :inline_job_queue do
  include_context 'algolia directory double'

  let(:offices_index_page) { SelfService::OfficesIndexPage.new }
  let(:office_edit_page) { SelfService::OfficeEditPage.new }

  let(:address_line_one) { '119 Holborn' }
  let(:address_town) { 'London' }
  let(:address_postcode) { 'EC1N 2TD' }

  let(:original_line_one) { address_line_one }
  let(:updated_line_one) { '120 Holborn' }
  let(:original_postcode) { address_postcode }

  let(:principal) { FactoryGirl.create(:principal) }
  let(:user) { FactoryGirl.create(:user, principal: principal) }
  let(:office) do
    FactoryGirl.create(:office,
                       firm: principal.firm,
                       address_line_one: address_line_one,
                       address_line_two: '',
                       address_town: address_town,
                       address_county: '',
                       address_postcode: address_postcode,
                       disabled_access: false)
  end
  let(:offices) { [office] }

  scenario 'The principal can edit their office' do
    given_i_am_a_fully_registered_principal_user
    and_my_firm_has_offices
    and_i_am_logged_in

    when_i_am_on_the_offices_page
    then_no_errors_are_displayed_on(the_page: offices_index_page)
    and_i_click_the_edit_link_for_my_office
    then_i_see_the_edit_page_for_my_office
    then_no_errors_are_displayed_on(the_page: office_edit_page)

    when_i_change_the_information
    and_i_click_save
    then_no_errors_are_displayed_on(the_page: office_edit_page)
    then_i_see_a_success_notice
    then_the_information_is_changed
    and_the_office_information_is_updated_in_the_directory
  end

  scenario 'The system shows validation messages if there are invalid inputs' do
    given_i_am_a_fully_registered_principal_user
    and_my_firm_has_offices
    and_i_am_logged_in

    when_i_am_on_the_offices_page
    and_i_click_the_edit_link_for_my_office
    then_i_see_the_edit_page_for_my_office

    when_i_invalidate_the_information
    and_i_click_save
    then_i_see_validation_messages
    then_the_information_is_not_changed
  end

  def given_i_am_a_fully_registered_principal_user
    principal.firm = FactoryGirl.build(:firm, fca_number: principal.fca_number)
    expect(Firm.registered.find(principal.firm.id)).to be_present
  end

  def and_my_firm_has_offices
    offices
    principal.firm.reload
  end

  def and_i_am_logged_in
    login_as(user, scope: :user)
  end

  def when_i_am_on_the_offices_page
    offices_index_page.load(firm_id: principal.firm.id)
    expect(offices_index_page).to be_displayed
  end

  def and_i_click_the_edit_link_for_my_office
    offices_index_page.offices.first.edit_link.click
  end

  def then_no_errors_are_displayed_on(the_page:)
    # Matching only on title-case 'Error' as the word 'error' appears in the
    # validation message preamble
    expect(the_page).not_to have_text %r{Error|[Ww]arn|[Ee]xception}
    expect(the_page.status_code).not_to eq(500)
  end

  def then_i_see_the_edit_page_for_my_office
    expect(office_edit_page).to be_displayed
    expect(office_edit_page.address_postcode.value).to have_text office.address_postcode
  end

  def when_i_change_the_information
    office_edit_page.address_line_one.set updated_line_one
    office_edit_page.disabled_access.set true
  end

  def when_i_invalidate_the_information
    office_edit_page.address_postcode.set 'clearly_not_a_valid_postcode'
  end

  def and_i_click_save
    office_edit_page.save_button.click
  end

  def then_i_see_a_success_notice
    expect(office_edit_page).to have_flash_message(text: I18n.t('self_service.office_edit.saved'))
  end

  def then_i_see_validation_messages
    expect(office_edit_page).to have_validation_summary
  end

  def then_the_information_is_changed
    office.reload
    expect(office.address_line_one).to eq updated_line_one
    expect(office.disabled_access).to eq true
  end

  def and_the_office_information_is_updated_in_the_directory
    directory_office = offices_in_directory.find do |elem|
      elem['objectID'] == office.id
    end

    expect(directory_office['address_line_one']).to eq updated_line_one
    expect(directory_office['disabled_access']).to eq true
  end

  def then_the_information_is_not_changed
    expect(office_edit_page.address_postcode.value).to eq 'clearly_not_a_valid_postcode'

    office.reload
    expect(office.address_postcode).to eq original_postcode
  end
end
