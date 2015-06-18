RSpec.feature 'Principal completes the firm questionnaire' do
  let(:questionnaire_page) { QuestionnairePage.new }
  let(:adviser_page) { AdviserPage.new }

  before do
    create(:in_person_advice_method)
    create(:other_advice_method)
    create(:initial_meeting_duration)
    create(:initial_advice_fee_structure)
    create(:ongoing_advice_fee_structure)
    create(:allowed_payment_method)
    create(:investment_size)
  end

  scenario 'Successfully complete the questionnaire' do
    given_my_principal_record_exists
    given_my_principal_logs_in
    given_i_have_selected_a_firm
    and_i_can_see_my_firm_name_and_fca_reference_number
    when_i_complete_all_mandatory_questions
    then_my_directory_listing_is_created
    and_i_am_directed_to_assign_advisers_to_my_firm_or_subsidiary
  end

  scenario 'Successfully complete the subsidiary questionnaire' do
    given_my_principal_record_exists
    given_my_principal_logs_in
    given_i_have_selected_a_subsidiary
    and_i_can_see_my_firm_name_and_fca_reference_number
    when_i_complete_all_mandatory_questions
    then_my_directory_listing_is_created
    and_i_am_directed_to_assign_advisers_to_my_firm_or_subsidiary
  end

  def given_my_principal_record_exists
    @principal = create(:principal)
    @user = FactoryGirl.create(:user, principal: @principal)
  end

  def given_my_principal_logs_in
    login_as(@user, scope: :user)
  end

  def given_i_have_selected_a_firm
    @firm = @principal.firm
    questionnaire_page.load(principal: @principal.token, firm: @firm.to_param)
  end

  def given_i_have_selected_a_subsidiary
    subsidiary = @principal.lookup_firm.subsidiaries.create!(name: 'Meh Meh Ltd')
    @firm = @principal.find_or_create_subsidiary(subsidiary.to_param)

    questionnaire_page.load(principal: @principal.token, firm: @firm.to_param)
  end

  def and_i_can_see_my_firm_name_and_fca_reference_number
    expect(questionnaire_page.firm_name.text).to eql(@firm.registered_name)
    expect(questionnaire_page.firm_fca_number.text).to eql(@firm.fca_number.to_s)
  end

  def complete_part_1(page)
    page.email_address.set Faker::Internet.email
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

  def when_i_complete_all_mandatory_questions
    questionnaire_page.tap do |p|
      complete_part_1(p)
      complete_part_2(p)
      complete_part_3(p)

      p.minimum_fee.set Faker::Number.number(4)
      p.investment_sizes.first.set true

      p.next_button.click
    end
  end

  def then_my_directory_listing_is_created
    @firm.reload.tap do |f|
      expect(f.email_address).to be_present
      expect(f.telephone_number).to be_present
      expect(f.address_line_one).to be_present
    end
  end

  def and_i_am_directed_to_assign_advisers_to_my_firm_or_subsidiary
    expect(adviser_page).to be_displayed
  end
end
