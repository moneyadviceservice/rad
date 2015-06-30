RSpec.feature 'The self service firm edit page' do
  include CheckboxGroupHelpers

  let(:firms_index_page) { SelfService::FirmsIndexPage.new }
  let(:firm_edit_page) { SelfService::FirmEditPage.new }
  let!(:firm_changes) do
    FactoryGirl.build(:firm,
                      retirement_income_products_flag: true,
                      pension_transfer_flag: false,
                      long_term_care_flag: true,
                      equity_release_flag: false,
                      inheritance_tax_and_estate_planning_flag: true,
                      wills_and_probate_flag: false,
                      other_flag: true)
  end

  scenario 'The principal can edit their firm' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_a_firm
    and_i_am_logged_in
    when_i_am_on_the_firms_page
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
    when_i_am_on_the_firms_page
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

  def when_i_am_on_the_firms_page
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

  def when_i_change_the_information
    complete_part_1
    complete_part_2
    complete_part_3
  end

  def when_i_invalidate_the_information
    firm_edit_page.email_address.set 'clearly_not_a_valid_email!'
  end

  def and_i_click_save
    firm_edit_page.save_button.click
  end

  def then_i_see_a_success_notice
    expect(firm_edit_page).to have_flash_message(text: I18n.t('self_service.firm_edit.saved'))
  end

  def then_i_see_validation_messages
    expect(firm_edit_page).to have_validation_summary
  end

  def and_the_information_is_changed
    validate_part_1
    validate_part_2
    validate_part_3

    @principal.reload
    expect(@principal.firm.email_address).to eq firm_changes.email_address
  end

  def and_the_information_is_not_changed
    expect(firm_edit_page.email_address.value).to eq 'clearly_not_a_valid_email!'
    @principal.reload
    expect(@principal.firm.email_address).to eq @original_firm_email
  end

  def complete_part_1
    firm_edit_page.tap do |p|
      p.email_address.set firm_changes.email_address
      p.telephone_number.set firm_changes.telephone_number
      p.address_line_one.set firm_changes.address_line_one
      p.address_town.set firm_changes.address_town
      p.address_county.set firm_changes.address_county
      p.address_postcode.set firm_changes.address_postcode
    end
  end

  def validate_part_1
    firm_edit_page.tap do |p|
      expect(p.email_address.value).to eq firm_changes.email_address
      expect(p.telephone_number.value).to eq firm_changes.telephone_number
      expect(p.address_line_one.value).to eq firm_changes.address_line_one
      expect(p.address_town.value).to eq firm_changes.address_town
      expect(p.address_county.value).to eq firm_changes.address_county
      expect(p.address_postcode.value).to eq firm_changes.address_postcode
    end
  end

  def complete_part_2
    firm_edit_page.tap do |p|
      p.retirement_income_products_flag.set firm_changes.retirement_income_products_flag
      p.pension_transfer_flag.set firm_changes.pension_transfer_flag
      p.long_term_care_flag.set firm_changes.long_term_care_flag
      p.equity_release_flag.set firm_changes.equity_release_flag
      p.inheritance_tax_and_estate_planning_flag.set firm_changes.inheritance_tax_and_estate_planning_flag
      p.wills_and_probate_flag.set firm_changes.wills_and_probate_flag
      p.other_flag.set firm_changes.other_flag
      p.minimum_fee.set firm_changes.minimum_fixed_fee
    end
  end

  def validate_part_2
    firm_edit_page.tap do |p|
      expect(p.retirement_income_products_flag?).to eq firm_changes.retirement_income_products_flag
      expect(p.pension_transfer_flag?).to eq firm_changes.pension_transfer_flag
      expect(p.long_term_care_flag?).to eq firm_changes.long_term_care_flag
      expect(p.equity_release_flag?).to eq firm_changes.equity_release_flag
      expect(p.inheritance_tax_and_estate_planning_flag?).to eq firm_changes.inheritance_tax_and_estate_planning_flag
      expect(p.wills_and_probate_flag?).to eq firm_changes.wills_and_probate_flag
      expect(p.other_flag?).to eq firm_changes.other_flag
      expect(p.minimum_fee.value).to eq firm_changes.minimum_fixed_fee.to_s
    end
  end

  def complete_part_3
    firm_edit_page.tap do |p|
      set_checkbox_group_state(p, InPersonAdviceMethod.all, firm_changes.in_person_advice_methods)
      set_checkbox_group_state(p, OtherAdviceMethod.all, firm_changes.other_advice_methods)
      p.offers_free_initial_meeting = firm_changes.free_initial_meeting
      p.choose(firm_changes.initial_meeting_duration.name)
      set_checkbox_group_state(p, InitialAdviceFeeStructure.all, firm_changes.initial_advice_fee_structures)
      set_checkbox_group_state(p, OngoingAdviceFeeStructure.all, firm_changes.ongoing_advice_fee_structures)
      set_checkbox_group_state(p, AllowedPaymentMethod.all, firm_changes.allowed_payment_methods)
    end
  end

  def validate_part_3
    firm_edit_page.tap do |p|
      expect_checkbox_group_state(p, InPersonAdviceMethod.all, firm_changes.in_person_advice_methods)
      expect_checkbox_group_state(p, OtherAdviceMethod.all, firm_changes.other_advice_methods)
      expect(p.offers_free_initial_meeting?).to eq(firm_changes.free_initial_meeting)
      expect(p).to have_checked_field(firm_changes.initial_meeting_duration.name)
      expect_checkbox_group_state(p, InitialAdviceFeeStructure.all, firm_changes.initial_advice_fee_structures)
      expect_checkbox_group_state(p, OngoingAdviceFeeStructure.all, firm_changes.ongoing_advice_fee_structures)
      expect_checkbox_group_state(p, AllowedPaymentMethod.all, firm_changes.allowed_payment_methods)
    end
  end
end
