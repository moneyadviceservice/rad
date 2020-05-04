RSpec.feature 'The self service firm edit page', :inline_job_queue do
  include CheckboxGroupHelpers
  include_context 'algolia index fake'

  let(:advisers_index_page) { SelfService::AdvisersIndexPage.new }
  let(:adviser_edit_page) { SelfService::AdviserEditPage.new }
  let(:original_postcode) { 'L1 2NH' }
  let(:updated_postcode) { 'EH11 2AB' }

  before do
    FactoryBot.create_list :accreditation, 5
    FactoryBot.create_list :qualification, 5
    FactoryBot.create_list :professional_standing, 5
  end

  scenario 'The principal can edit their adviser' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_a_firm_with_an_adviser
    and_i_am_logged_in
    when_i_am_on_the_advisers_page
    and_i_click_the_edit_link_for_my_adviser
    then_i_see_the_edit_page_for_my_adviser
    when_i_change_the_information
    and_i_click_save
    then_i_see_a_success_notice
    and_the_information_is_changed
    and_the_adviser_information_is_updated_in_the_directory
  end

  scenario 'The system shows validation messages if there are invalid inputs' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_a_firm_with_an_adviser
    and_i_am_logged_in
    when_i_am_on_the_advisers_page
    and_i_click_the_edit_link_for_my_adviser
    then_i_see_the_edit_page_for_my_adviser
    when_i_invalidate_the_information
    and_i_click_save
    then_i_see_validation_messages
    and_the_information_is_not_changed
  end

  def given_i_am_a_fully_registered_principal_user
    @principal = FactoryBot.create(:principal)
    @user = FactoryBot.create(:user, principal: @principal)
  end

  def and_i_have_a_firm_with_an_adviser
    @adviser = FactoryBot.create :advisers_retirement_firm, postcode: original_postcode
    firm_attrs = FactoryBot.attributes_for(:firm, fca_number: @principal.fca_number)
    @principal.firm.advisers << @adviser
    @principal.firm.update(firm_attrs)
  end

  def and_i_am_logged_in
    login_as(@user, scope: :user)
  end

  def when_i_am_on_the_advisers_page
    advisers_index_page.load(firm_id: @principal.firm.id)
    expect(advisers_index_page).to be_displayed
  end

  def and_i_click_the_edit_link_for_my_adviser
    advisers_index_page.advisers.first.edit_link.click
  end

  def then_i_see_the_edit_page_for_my_adviser
    expect(adviser_edit_page).to be_displayed
    expect(adviser_edit_page.adviser_postcode.value).to have_text @adviser.postcode
  end

  def when_i_change_the_information
    adviser_edit_page.adviser_postcode.set updated_postcode
    adviser_edit_page.travel_distance.select '250 miles'
    set_checkbox_group_state(adviser_edit_page, Accreditation.all, Accreditation.last(1))
    set_checkbox_group_state(adviser_edit_page, Qualification.all, Qualification.last(1))
    set_checkbox_group_state(adviser_edit_page, ProfessionalStanding.all, ProfessionalStanding.last(1))
  end

  def when_i_invalidate_the_information
    adviser_edit_page.adviser_postcode.set 'clearly_not_a_valid_postcode'
  end

  def and_i_click_save
    adviser_edit_page.save_button.click
  end

  def then_i_see_a_success_notice
    expect(adviser_edit_page).to have_flash_message(text: I18n.t('self_service.adviser_edit.saved'))
  end

  def then_i_see_validation_messages
    expect(adviser_edit_page).to have_validation_summary
  end

  def and_the_information_is_changed
    @adviser.reload
    expect(@adviser.postcode).to eq updated_postcode
    expect(@adviser.travel_distance).to eq 250
    expect(@adviser.accreditations).to include(Accreditation.last)
    expect(@adviser.qualifications).to include(Qualification.last)
    expect(@adviser.professional_standings).to include(ProfessionalStanding.last)
  end

  def and_the_information_is_not_changed
    expect(adviser_edit_page.adviser_postcode.value).to eq 'CLEARLY_NOT_A_VALID_POSTCODE'

    @adviser.reload
    expect(@adviser.postcode).to eq original_postcode
  end

  def and_the_adviser_information_is_updated_in_the_directory
    directory_adviser = advisers_in_directory.find do |elem|
      elem['objectID'] == @adviser.id
    end

    expect(directory_adviser['postcode']).to eq updated_postcode
  end
end
