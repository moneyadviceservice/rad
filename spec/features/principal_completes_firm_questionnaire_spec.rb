RSpec.feature 'Principal completes the firm questionnaire' do
  let(:questionnaire_page) { QuestionnairePage.new }
  let(:adviser_page) { AdviserPage.new }

  before do
    FactoryGirl.create(:in_person_advice_method)
    FactoryGirl.create(:other_advice_method)
    FactoryGirl.create(:initial_meeting_duration)
    FactoryGirl.create(:initial_advice_fee_structure)
    FactoryGirl.create(:ongoing_advice_fee_structure)
    FactoryGirl.create(:allowed_payment_method)
    FactoryGirl.create(:investment_size)
  end

  scenario 'Successfully complete the questionnaire' do
    given_i_have_selected_a_firm
    and_i_can_see_my_firm_name_and_fca_reference_number
    when_I_complete_all_mandatory_questions
    then_my_directory_listing_is_created_and_marked_as_done
    and_i_am_directed_to_assign_advisers_to_my_firm_or_subsidiary
  end

  def given_i_have_selected_a_firm
    @principal = create(:principal)
    questionnaire_page.load(principal: @principal.token)
  end

  def and_i_can_see_my_firm_name_and_fca_reference_number
    expect(questionnaire_page.firm_name.text).to eql(@principal.firm.registered_name)
    expect(questionnaire_page.firm_fca_number.text).to eql(@principal.firm.fca_number.to_s)
  end

  def when_I_complete_all_mandatory_questions
    questionnaire_page.email_address_field.set(Faker::Internet.email)
    questionnaire_page.telephone_number_field.set(Faker::Base.numerify('##### ### ###'))
    questionnaire_page.address_line_1_field.set(Faker::Address.street_address)
    questionnaire_page.address_town_field.set(Faker::Address.city)
    questionnaire_page.address_county_field.set(Faker::Address.county)
    questionnaire_page.address_postcode_field.set(Faker::Address.postcode)

    questionnaire_page.in_person_advice_method_checkboxes.first.set(true)
    questionnaire_page.other_advice_method_checkboxes.first.set(true)
    questionnaire_page.offers_free_initial_meeting_radio_button.set(true)
    questionnaire_page.initial_meeting_duration_checkboxes.first.set(true)
    questionnaire_page.initial_fee_structure_checkboxes.first.set(true)
    questionnaire_page.ongoing_fee_structure_checkboxes.first.set(true)
    questionnaire_page.allowed_payment_method_checkboxes.first.set(true)
    questionnaire_page.minimum_fee_field.set(Faker::Number.number(4))

    questionnaire_page.firm_retirement_income_products_percent_field.set(15)
    questionnaire_page.firm_pension_transfer_percent_field.set(15)
    questionnaire_page.firm_long_term_care_percent_field.set(15)
    questionnaire_page.firm_equity_release_percent_field.set(15)
    questionnaire_page.firm_inheritance_tax_and_estate_planning_percent_field.set(15)
    questionnaire_page.firm_wills_and_probate_percent_field.set(15)
    questionnaire_page.firm_other_percent_field.set(10)

    questionnaire_page.investment_size_checkboxes.first.set(true)

    questionnaire_page.next_button.click
  end

  def then_my_directory_listing_is_created_and_marked_as_done
    @principal.firm.reload

    expect(@principal.firm).to be_valid
  end

  def and_i_am_directed_to_assign_advisers_to_my_firm_or_subsidiary
    expect(adviser_page).to be_displayed
  end
end
