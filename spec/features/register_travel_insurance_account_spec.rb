RSpec.feature 'Principal provides travel insurance information', :inline_job_queue do
  include_context 'algolia index fake'

  let(:travel_insurance_registration_page) do
    TravelInsuranceRegistrationPage.new
  end

  let(:thank_you_for_registering_page) do
    TravelInsuranceRegistrationThankYouPage.new
  end

  let(:travel_insurance_risk_profile_page) do
    TravelInsuranceRiskProfilePage.new
  end

  let(:travel_insurance_medical_conditions_page) do
    TravelInsuranceMedicalConditionsPage.new
  end

  let(:travel_insurance_medical_conditions_questionaire_page) do
    TravelInsuranceMedicalConditionsQuestionairePage.new
  end

  let(:rejection_page) { TravelInsuranceRejectionPage.new }
  let(:sign_in_page) { SignInPage.new }

  let(:travel_insurance_firm_page) do
    Admin::TravelInsuranceFirmPage.new
  end

  before { ActionMailer::Base.deliveries.clear }

  context 'Step 1' do
    scenario 'Registering a travel insurance firm' do
      given_i_am_on_the_travel_insurance_registration_page
      when_i_provide_my_firms_fca_reference_number
      and_i_provide_my_identifying_particulars
      then_i_am_taken_to_the_second_step_of_signup
    end

    scenario 'Re-registering the same travel insurance firm' do
      given_i_am_on_the_travel_insurance_registration_page
      and_i_registered_a_principal_and_travel_insurance_firm
      when_i_provide_my_firms_fca_reference_number
      and_i_provide_my_identifying_particulars
      then_i_am_told_which_fields_are_incorrect_and_why
    end
  end

  context 'Step 2' do
    scenario 'Not filling all required fields' do
      given_i_am_on_the_travel_insurance_risk_profile_page
      and_i_provide_incomplete_answers_to_step_2
      then_i_am_told_which_fields_are_incorrect_and_why
    end

    scenario 'a firm that chooses that they are not convered by the ombudsman' do
      given_i_am_on_the_travel_insurance_risk_profile_page
      and_i_provide_information_that_our_firm_is_not_covered_by_ombudsman
      then_i_am_notified_i_cannot_proceed
      and_admins_later_receive_an_email_about_the_rejection
    end

    scenario 'a firm that chooses that they cannot supply documentation' do
      given_i_am_on_the_travel_insurance_risk_profile_page
      and_i_provide_information_that_my_company_cannot_supply_documentation
      then_i_am_notified_i_cannot_proceed
      and_admins_later_receive_an_email_about_the_rejection
    end

    scenario 'a firm that chooses neither for risk profiling approach' do
      given_i_am_on_the_travel_insurance_risk_profile_page
      and_i_provide_information_that_our_risk_profile_approach_is_neither
      then_i_am_notified_i_cannot_proceed
      and_admins_later_receive_an_email_about_the_rejection
    end

    scenario 'a firm that offers a bespoke risk profiling approach' do
      given_i_am_on_the_travel_insurance_risk_profile_page
      and_i_provide_a_bespoke_risk_profile_approach
      then_i_am_taken_to_the_third_step_of_signup
    end

    scenario 'a firm that offers a questionaire as risk profiling approach' do
      given_i_am_on_the_travel_insurance_risk_profile_page
      and_i_provide_information_that_my_company_offers_a_questionaire
      then_i_am_taken_to_the_third_step_of_signup
    end
  end

  context 'Step 3' do
    scenario 'Not filling all required fields' do
      given_i_am_on_the_travel_insurance_medical_conditions_page
      and_i_provide_incomplete_answers_to_step_3
      then_i_am_told_which_fields_are_incorrect_and_why
    end

    scenario 'a firm that supports one_specific type of medical condition' do
      given_i_am_on_the_travel_insurance_medical_conditions_page
      and_i_provide_information_that_my_company_covers_one_specific_medical_condition
      then_i_am_shown_a_thank_you_for_registering_message
      and_i_should_have_a_travel_insurance_firm
      and_i_later_receive_an_email_confirming_my_registration
    end

    scenario 'a firm that supports all_conditions type of medical conditions' do
      given_i_am_on_the_travel_insurance_medical_conditions_page
      and_i_provide_information_that_my_company_covers_all_medical_conditions
      then_i_am_taken_to_the_fourth_step_of_signup
    end
  end

  context 'Step 4' do
    scenario 'Not filling all required fields' do
      given_i_am_on_the_travel_insurance_medical_conditions_questionaire_page
      and_i_provide_incomplete_answers_to_step_4
      then_i_am_told_which_fields_are_incorrect_and_why
    end

    scenario 'a firm that supports answers yes to all questions' do
      given_i_am_on_the_travel_insurance_medical_conditions_questionaire_page
      and_i_answer_yes_to_questions_on_step_4(15)
      then_i_am_shown_a_thank_you_for_registering_message
      and_i_should_have_a_travel_insurance_firm
      and_i_later_receive_an_email_confirming_my_registration
      and_i_should_see_that_my_company_covers_all_medical_conditions_on_the_firm_admin_page
      and_i_should_see_all_questionaire_questions_as_true_on_the_firm_admin_page
    end

    scenario 'a firm that answers yes to 8 questions and the rest no' do
      given_i_am_on_the_travel_insurance_medical_conditions_questionaire_page
      and_i_answer_yes_to_questions_on_step_4(12)
      then_i_am_shown_a_thank_you_for_registering_message
      and_i_should_have_a_travel_insurance_firm
      and_i_later_receive_an_email_confirming_my_registration
    end

    scenario 'a firm that answers yes to 7 questions and the rest no' do
      given_i_am_on_the_travel_insurance_medical_conditions_questionaire_page
      and_i_answer_yes_to_questions_on_step_4(11)
      then_i_am_notified_i_cannot_proceed
      and_admins_later_receive_an_email_about_the_rejection
    end
  end

  scenario 'Registering a travel insurance firm having a retirement firm' do
    given_i_am_on_the_travel_insurance_medical_conditions_questionaire_page
    and_i_registered_a_principal_and_retirement_advice_firm
    and_i_answer_yes_to_questions_on_step_4(15)
    then_i_am_shown_a_thank_you_for_registering_message
    and_i_should_have_a_retirement_and_travel_insurance_firm
    and_i_later_receive_an_email_confirming_my_registration
  end

  def given_i_am_on_the_travel_insurance_registration_page
    travel_insurance_registration_page.load
  end

  def and_i_should_see_the_bespoke_risk_profile_answer_on_the_firm_admin_page
    principal = Principal.find_by(fca_number: '311244')
    travel_insurance_firm_page.load(firm_id: principal.travel_insurance_firm.id)
    expect(
      travel_insurance_firm_page.registration_questions.text
    ).to match(/^.*risk_profile_approach_question bespoke.*/)
  end

  def and_i_should_see_all_questionaire_questions_as_true_on_the_firm_admin_page
    questions = I18n.t('registration.medical_conditions_questionaire').keys
    principal = Principal.find_by(fca_number: '311244')
    travel_insurance_firm_page.load(firm_id: principal.travel_insurance_firm.id)

    questions.each_with_index do |question, _index|
      expect(
        travel_insurance_firm_page.registration_questions.text
      ).to match(/^.*#{question} true.*/)
    end
  end

  def and_i_should_see_that_my_company_covers_all_medical_conditions_on_the_firm_admin_page
    principal = Principal.find_by(fca_number: '311244')
    travel_insurance_firm_page.load(firm_id: principal.travel_insurance_firm.id)
    expect(
      travel_insurance_firm_page.registration_questions.text
    ).to match(/^.*covers_medical_condition_question all.*/)
  end

  def given_i_am_on_the_travel_insurance_risk_profile_page
    given_i_am_on_the_travel_insurance_registration_page
    when_i_provide_my_firms_fca_reference_number
    and_i_provide_my_identifying_particulars

    travel_insurance_risk_profile_page.load
  end

  def given_i_am_on_the_travel_insurance_medical_conditions_page
    given_i_am_on_the_travel_insurance_risk_profile_page
    and_i_provide_information_that_my_company_offers_a_questionaire
    travel_insurance_medical_conditions_page.load
  end

  def given_i_am_on_the_travel_insurance_medical_conditions_questionaire_page
    given_i_am_on_the_travel_insurance_medical_conditions_page
    and_i_provide_information_that_my_company_covers_all_medical_conditions
    travel_insurance_medical_conditions_questionaire_page.load
  end

  def and_i_provide_information_that_our_risk_profile_approach_is_neither
    travel_insurance_risk_profile_page.tap do |p|
      p.covered_by_ombudsman_question.choose 'Yes'
      p.risk_profile_approach_question.choose I18n.t('registration.risk_profile_approach_question.answers.neither')
      p.supplies_documentation_when_needed_question.choose 'Yes'
      p.register.click
    end
  end

  def and_i_provide_information_that_my_company_cannot_supply_documentation
    travel_insurance_risk_profile_page.tap do |p|
      p.covered_by_ombudsman_question.choose 'Yes'
      p.risk_profile_approach_question.choose I18n.t('registration.risk_profile_approach_question.answers.bespoke')
      p.supplies_documentation_when_needed_question.choose 'No'
      p.register.click
    end
  end

  def and_i_provide_information_that_my_company_offers_a_questionaire
    travel_insurance_risk_profile_page.tap do |p|
      p.covered_by_ombudsman_question.choose 'Yes'
      p.risk_profile_approach_question.choose I18n.t('registration.risk_profile_approach_question.answers.questionaire')
      p.supplies_documentation_when_needed_question.choose 'Yes'
      p.register.click
    end
  end

  def and_i_provide_information_that_our_firm_is_not_covered_by_ombudsman
    travel_insurance_risk_profile_page.tap do |p|
      p.covered_by_ombudsman_question.choose 'No'
      p.risk_profile_approach_question.choose I18n.t('registration.risk_profile_approach_question.answers.bespoke')
      p.supplies_documentation_when_needed_question.choose 'Yes'

      VCR.use_cassette('registrations_fca_firm_api_call', allow_playback_repeats: true) do
        p.register.click
      end
    end
  end

  def and_i_provide_a_bespoke_risk_profile_approach
    travel_insurance_risk_profile_page.tap do |p|
      p.covered_by_ombudsman_question.choose 'Yes'
      p.risk_profile_approach_question.choose I18n.t('registration.risk_profile_approach_question.answers.bespoke')
      p.supplies_documentation_when_needed_question.choose 'Yes'

      VCR.use_cassette('registrations_fca_firm_api_call', allow_playback_repeats: true) do
        p.register.click
      end
    end
  end

  def and_i_provide_information_that_my_company_covers_one_specific_medical_condition
    travel_insurance_medical_conditions_page.tap do |p|
      p.covers_medical_condition_question.choose I18n.t('registration.covers_medical_condition_question.answers.one_specific')

      VCR.use_cassette('registrations_fca_firm_api_call', allow_playback_repeats: true) do
        p.register.click
      end
    end
  end

  def and_i_provide_information_that_my_company_covers_all_medical_conditions
    travel_insurance_medical_conditions_page.tap do |p|
      p.covers_medical_condition_question.choose I18n.t('registration.covers_medical_condition_question.answers.all_conditions')
      p.register.click
    end
  end

  def when_i_provide_my_firms_fca_reference_number
    travel_insurance_registration_page.reference_number.set '311244'
  end

  def and_i_provide_my_identifying_particulars
    travel_insurance_registration_page.tap do |p|
      p.first_name.set principal_details.first_name
      p.last_name.set principal_details.last_name
      p.job_title.set principal_details.job_title
      p.individual_reference_number.set principal_details.individual_reference_number
      p.email.set principal_details.email_address
      p.password.set 'Password1!'
      p.password_confirmation.set 'Password1!'
      p.telephone_number.set principal_details.telephone_number

      p.confirmation.set true

      VCR.use_cassette('registrations_fca_firm_api_call', allow_playback_repeats: true) do
        p.register.click
      end
    end
  end

  def and_i_provide_incomplete_answers_to_step_2
    travel_insurance_risk_profile_page.tap do |p|
      p.covered_by_ombudsman_question.choose 'Yes'
      p.register.click
    end
  end

  def and_i_provide_incomplete_answers_to_step_3
    travel_insurance_medical_conditions_page.tap do |p|
      p.register.click
    end
  end

  def and_i_provide_incomplete_answers_to_step_4
    travel_insurance_medical_conditions_questionaire_page.tap do |p|
      p.register.click
    end
  end

  def and_i_answer_yes_to_questions_on_step_4(how_many)
    questions = I18n.t('registration.medical_conditions_questionaire').keys

    travel_insurance_medical_conditions_questionaire_page.tap do |p|
      questions.each_with_index do |question, index|
        answer = index < how_many ? 'Yes' : 'No'
        p.send(question).send(:choose, answer)
      end

      VCR.use_cassette('registrations_fca_firm_api_call', allow_playback_repeats: true) do
        p.register.click
      end
    end
  end

  def and_i_later_receive_an_email_confirming_my_registration
    email =
      ActionMailer::Base.deliveries.find do |mail|
        mail.subject.match?(/Your Directory Account/)
      end

    expect(email).to_not be_nil
    expect(email.body.raw_source).to include('Travel Insurance Directory')
  end

  def and_admins_later_receive_an_email_about_the_rejection
    email =
      ActionMailer::Base.deliveries.find do |mail|
        mail.subject.match?(/rejected firm/)
      end

    expect(email).to_not be_nil
    expect(email.body.raw_source).to include('311244')
    expect(email.body.raw_source).to include(principal_details.first_name)
    expect(email.body.raw_source).to include(principal_details.last_name)
    expect(email.body.raw_source).to include(principal_details.email_address)
  end

  def and_i_registered_a_principal_and_retirement_advice_firm
    principal = create_principal
    expect(principal.firm).to_not be_nil
    expect(principal.travel_insurance_firm).to be_nil
  end

  def and_i_registered_a_principal_and_travel_insurance_firm
    fca_number = '311244'
    principal = create_principal(
      manually_build_firms: true,
      fca_number: fca_number
    )

    FactoryBot.create(:travel_insurance_firm, fca_number: fca_number, approved_at: nil)

    expect(principal.firm).to be_nil
    expect(principal.travel_insurance_firm).to_not be_nil
  end

  def then_i_am_taken_to_the_second_step_of_signup
    expect(travel_insurance_risk_profile_page).to have_content(
      'Step 2 of 4'
    )
  end

  def then_i_am_taken_to_the_third_step_of_signup
    expect(travel_insurance_medical_conditions_page).to have_content(
      'Step 3 of 4'
    )
  end

  def then_i_am_taken_to_the_fourth_step_of_signup
    expect(travel_insurance_medical_conditions_page).to have_content(
      'Step 4 of 4'
    )
  end

  def then_i_am_shown_a_thank_you_for_registering_message
    expect(thank_you_for_registering_page).to have_content(
      I18n.t('success.travel_insurance_registrations.heading')
    )
    expect(thank_you_for_registering_page).to have_content(
      I18n.t('success.travel_insurance_registrations.message')
    )
  end

  def then_i_am_notified_i_cannot_proceed
    expect(rejection_page).to be_displayed
  end

  def and_i_should_have_a_travel_insurance_firm
    principal = Principal.find_by(fca_number: '311244')
    expect(principal.travel_insurance_firm).to_not be_nil
  end

  def and_i_should_have_a_retirement_and_travel_insurance_firm
    principal = Principal.find_by(fca_number: '311244')
    expect(principal.firm).to_not be_nil
    expect(principal.travel_insurance_firm).to_not be_nil
  end

  def then_i_am_told_which_fields_are_incorrect_and_why
    expect(travel_insurance_registration_page).to have_validation_summaries
  end

  private

  def create_principal(attributes = {})
    principal = FactoryBot.create(
      :principal,
      { fca_number: '311244' }.merge(attributes).merge(principal_details.to_h)
    )
    FactoryBot.create(
      :user,
      email: principal_details.email_address,
      principal: principal
    )
    principal
  end

  def principal_details
    OpenStruct.new(
      first_name: 'test',
      last_name: 'principal',
      individual_reference_number: 'LXD25428',
      job_title: 'The tester',
      email_address: 'test@moneyadviceservice.org.uk',
      telephone_number: '07777 777 777'
    )
  end
end
