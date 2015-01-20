RSpec.feature 'Principal completes the firm questionnaire' do
  let(:questionnaire_page) { QuestionnairePage.new }

  before do
    FactoryGirl.create(:service_region)
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
    questionnaire_page.next_button.click
  end

  def then_my_directory_listing_is_created_and_marked_as_done
    skip('waiting on dependant story')
  end

  def and_i_am_directed_to_assign_advisers_to_my_firm_or_subsidiary
    skip('waiting on dependant story')
  end
end
