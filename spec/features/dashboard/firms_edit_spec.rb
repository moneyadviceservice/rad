RSpec.feature 'The dashboard firm edit page' do
  let(:firms_index_page) { Dashboard::FirmsIndexPage.new }
  let(:firm_edit_page) { Dashboard::FirmEditPage.new }

  scenario 'The principal can edit their firm' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_a_firm
    and_i_am_logged_in
    when_i_am_on_the_principal_dashboard_firms_page
    and_i_click_the_edit_link_for_my_firm
    then_i_see_the_edit_page_for_my_firm
    when_i_change_the_information
    and_i_click_save
    then_i_see_a_success_notice
    and_the_information_is_changed
  end

  scenario 'The system shows validation messages if there are invalid inputs' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_a_firm
    and_i_am_logged_in
    when_i_am_on_the_principal_dashboard_firms_page
    and_i_click_the_edit_link_for_my_firm
    then_i_see_the_edit_page_for_my_firm
    when_i_invalidate_the_information
    and_i_click_save
    then_i_see_validation_messages
    and_the_information_is_not_changed
  end

  def given_i_am_a_fully_registered_principal_user
    @principal = FactoryGirl.create(:principal)
    @user = FactoryGirl.create(:user, principal: @principal)
  end

  def and_i_have_a_firm
    firm_attrs = FactoryGirl.attributes_for(:firm, fca_number: @principal.fca_number)
    @principal.firm.update_attributes(firm_attrs)
    @original_firm_email = @principal.firm.email_address
  end

  def and_i_am_logged_in
    login_as(@user, scope: :user)
  end

  def when_i_am_on_the_principal_dashboard_firms_page
    firms_index_page.load
    expect(firms_index_page).to be_displayed
  end

  def and_i_click_the_edit_link_for_my_firm
    firms_index_page.parent_firm.edit_link.click
  end

  def then_i_see_the_edit_page_for_my_firm
    expect(firm_edit_page).to be_displayed
    expect(firm_edit_page.firm_name).to have_text @principal.firm.registered_name
  end

  def when_i_invalidate_the_information
    firm_edit_page.email_address.set 'clearly_not_a_valid_email!'
  end

  def and_i_click_save
    firm_edit_page.save_button.click
  end

  def then_i_see_a_success_notice
    expect(firm_edit_page).to have_flash_message(text: I18n.t('dashboard.firm_edit.saved'))
  end

  def then_i_see_validation_messages
    expect(firm_edit_page).to have_validation_summary
  end

  def and_the_information_is_changed
    expect(firm_edit_page.email_address.value).to eq 'i_dunno@example.com'
    @principal.reload
    expect(@principal.firm.email_address).to eq 'i_dunno@example.com'
  end

  def and_the_information_is_not_changed
    expect(firm_edit_page.email_address.value).to eq 'clearly_not_a_valid_email!'
    @principal.reload
    expect(@principal.firm.email_address).to eq @original_firm_email
  end

  # ---------------------------------------------------------------------------

  def complete_part_1(page)
    page.email_address.set 'i_dunno@example.com'
    page.telephone_number.set Faker::Base.numerify('##### ### ###')
    page.address_line_one.set Faker::Address.street_address
    page.address_town.set Faker::Address.city
    page.address_county.set Faker::Address.county
    page.address_postcode.set Faker::Address.postcode
  end

  def complete_part_2(page)
    page.in_person_advice_methods.first.set true
    page.other_advice_methods.first.set true
    page.offers_free_initial_meeting.set true
    page.initial_meeting_durations.first.set true
    page.initial_fee_structures.first.set true
    page.ongoing_fee_structures.first.set true
    page.allowed_payment_methods.first.set true
  end

  def complete_part_3(page)
    page.retirement_income_products_percent.set 15
    page.pension_transfer_percent.set 15
    page.long_term_care_percent.set 15
    page.equity_release_percent.set 15
    page.inheritance_tax_and_estate_planning_percent.set 15
    page.wills_and_probate_percent.set 15
    page.other_percent.set 10
  end

  def when_i_change_the_information
    firm_edit_page.tap do |p|
      complete_part_1(p)
      complete_part_2(p)
      complete_part_3(p)

      p.minimum_fee.set Faker::Number.number(4)
      p.investment_sizes.first.set true
    end
  end
end
