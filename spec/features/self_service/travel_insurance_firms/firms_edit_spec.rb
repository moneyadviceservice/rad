RSpec.feature 'The self service TravelInsurance firm edit page' do
  let(:firms_index_page) { SelfService::TravelInsuranceFirms::IndexPage.new }
  let(:firm_edit_page) { SelfService::TravelInsuranceFirms::FirmEditPage.new }

  let!(:principal) { FactoryBot.create(:principal) }
  let!(:firm) { FactoryBot.create(:travel_insurance_firm, principal: principal) }
  let(:user) { FactoryBot.create(:user, principal: principal) }

  scenario 'The principal can see a back to firms list link' do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in
    when_i_am_on_the_travel_insurance_index_page
    and_i_click_the_cover_and_service_link
    then_i_see_the_edit_page_for_my_firm
    then_i_see_a_back_to_firms_list_link
  end

  scenario 'The principal can see the status of each cover areas' do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in
    when_i_am_on_the_travel_insurance_index_page
    and_i_click_the_cover_and_service_link
    then_i_see_the_edit_page_for_my_firm
    then_i_see_the_status_for_each_cover_area
  end

  scenario 'The principal can edit their firms details and complete a tab' do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in
    when_i_am_on_the_travel_insurance_index_page
    and_i_click_the_cover_and_service_link
    then_i_see_the_edit_page_for_my_firm
    when_i_change_the_information
    and_i_click_save
    then_i_see_a_success_notice
    then_i_can_see_europe_tab_completed_but_not_the_others
  end

  scenario 'The principal can update all the details' do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in
    when_i_am_on_the_travel_insurance_index_page
    and_i_click_the_cover_and_service_link
    then_i_see_the_edit_page_for_my_firm
    when_i_complete_all_the_form
    and_i_click_save
    then_i_see_a_success_notice
    then_i_can_see_all_tabs_marked_as_completed
  end

  def given_i_am_a_fully_registered_principal_user
    firm_attrs = FactoryBot.attributes_for(:travel_insurance_firm, fca_number: principal.fca_number)
    principal.travel_insurance_firm.update(firm_attrs)
    expect(TravelInsuranceFirm.find(principal.travel_insurance_firm.id)).to be_present
  end

  def and_i_am_logged_in
    login_as(user, scope: :user)
  end

  def when_i_am_on_the_travel_insurance_index_page
    firms_index_page.load
    expect(firms_index_page).to be_displayed
  end

  def and_i_click_the_cover_and_service_link
    firms_index_page.cover_and_service_link.click
  end

  def then_i_see_the_edit_page_for_my_firm
    expect(firm_edit_page).to be_displayed
  end

  def then_i_see_a_back_to_firms_list_link
    expect(firm_edit_page).to have_back_to_firms_list_link
  end

  def then_i_see_the_status_for_each_cover_area
    expect(firm_edit_page).to have_europe_tab_status
    expect(firm_edit_page).to have_worldwide_excluding_us_tab_status
    expect(firm_edit_page).to have_worldwide_including_us_tab_status
  end

  def then_i_see_a_success_notice
    expect(firm_edit_page).to have_flash_message(text: I18n.t('self_service.firm_edit.saved'))
  end

  def then_i_can_see_europe_tab_is_completed
    completed_text = I18n.t!('self_service.status.complete')
    expect(firm_edit_page.europe_tab_status).to have_text(completed_text)
  end

  def then_i_can_see_europe_tab_completed_but_not_the_others
    completed_text = I18n.t!('self_service.status.complete')
    needs_more_info_text = I18n.t!('self_service.status.unpublished')

    expect(firm_edit_page.europe_tab_status).to have_text(completed_text)
    expect(firm_edit_page.worldwide_excluding_us_tab_status).to have_text(needs_more_info_text)
    expect(firm_edit_page.worldwide_including_us_tab_status).to have_text(needs_more_info_text)
  end

  def then_i_can_see_all_tabs_marked_as_completed
    completed_text = I18n.t!('self_service.status.complete')

    expect(firm_edit_page.europe_tab_status).to have_text(completed_text)
    expect(firm_edit_page.worldwide_excluding_us_tab_status).to have_text(completed_text)
    expect(firm_edit_page.worldwide_including_us_tab_status).to have_text(completed_text)
  end

  def and_i_click_save
    firm_edit_page.save_button.click
  end

  def when_i_change_the_information
    complete_europe_tab
  end

  def when_i_complete_all_the_form
    complete_europe_tab
    complete_worldwide_excluding_us_tab
    complete_worldwide_including_us_tab
    complete_service_details
  end

  def complete_europe_tab
    firm_edit_page.tap do |p|
      p.single_europe_30_days_land.select('68')
      p.single_europe_30_days_cruise.select('68')
      p.single_europe_45_days_land.select('68')
      p.single_europe_45_days_cruise.select('68')
      p.single_europe_55_days_land.select('68')
      p.single_europe_55_days_cruise.select('68')

      p.annual_europe_30_days_land.select('68')
      p.annual_europe_30_days_cruise.select('68')
      p.annual_europe_45_days_land.select('68')
      p.annual_europe_45_days_cruise.select('68')
      p.annual_europe_55_days_land.select('68')
      p.annual_europe_55_days_cruise.select('68')
    end
  end

  def complete_worldwide_excluding_us_tab
    firm_edit_page.tap do |p|
      p.single_worldwide_excluding_us_30_days_land.select('68')
      p.single_worldwide_excluding_us_30_days_cruise.select('68')
      p.single_worldwide_excluding_us_45_days_land.select('68')
      p.single_worldwide_excluding_us_45_days_cruise.select('68')
      p.single_worldwide_excluding_us_55_days_land.select('68')
      p.single_worldwide_excluding_us_55_days_cruise.select('68')

      p.annual_worldwide_excluding_us_30_days_land.select('68')
      p.annual_worldwide_excluding_us_30_days_cruise.select('68')
      p.annual_worldwide_excluding_us_45_days_land.select('68')
      p.annual_worldwide_excluding_us_45_days_cruise.select('68')
      p.annual_worldwide_excluding_us_55_days_land.select('68')
      p.annual_worldwide_excluding_us_55_days_cruise.select('68')
    end
  end

  def complete_worldwide_including_us_tab
    firm_edit_page.tap do |p|
      p.single_worldwide_including_us_30_days_land.select('68')
      p.single_worldwide_including_us_30_days_cruise.select('68')
      p.single_worldwide_including_us_45_days_land.select('68')
      p.single_worldwide_including_us_45_days_cruise.select('68')
      p.single_worldwide_including_us_55_days_land.select('68')
      p.single_worldwide_including_us_55_days_cruise.select('68')

      p.annual_worldwide_including_us_30_days_land.select('68')
      p.annual_worldwide_including_us_30_days_cruise.select('68')
      p.annual_worldwide_including_us_45_days_land.select('68')
      p.annual_worldwide_including_us_45_days_cruise.select('68')
      p.annual_worldwide_including_us_55_days_land.select('68')
      p.annual_worldwide_including_us_55_days_cruise.select('68')
    end
  end

  def complete_service_details
    firm_edit_page.tap do |p|
      p.offers_telephone_quote_yes.set(true)
      p.covers_undergoing_treatment_yes.set(true)
    end
  end

  def complete_medical_specialism_details
    firm_edit_page.tap do |p|
      p.specialised_medical_conditions_yes.set(true)
      p.covers_specialist_equipment_yes.set(true)
    end
  end
end
