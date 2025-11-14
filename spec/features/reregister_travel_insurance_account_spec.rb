RSpec.feature 'Principal reregisters their travel insurance information', :inline_job_queue do
  include_context 'algolia index fake'

  scenario 'Successfully reregistering an existing listed firm' do
    given_i_am_logged_in_with_my_registered_firm
    when_i_attempt_to_reregister_my_firm
    and_confirm_the_fca_number_and_disclaimer
    and_complete_the_qualifying_questions
    and_complete_the_medical_questions
    then_the_firm_is_marked_for_reregistration
  end

  def given_i_am_logged_in_with_my_registered_firm
    @firm = create(:travel_insurance_firm_with_principal, :approved)
    @user = create(:user, principal: @firm.principal)

    login_as(@user)
  end

  def when_i_attempt_to_reregister_my_firm
    visit '/reregister'
    expect(page).to have_text('Step 1 of 4')
  end

  def and_confirm_the_fca_number_and_disclaimer
    expect(find('.t-reference-number').value).to eq(@firm.fca_number.to_s)

    check I18n.t('travel_insurance_reregistrations.confirmation_statement')
    click_button I18n.t('travel_insurance_reregistrations.register_button')
  end

  def and_complete_the_qualifying_questions
    expect(page).to have_text('Step 2 of 4')

    within('.t-covered_by_ombudsman_question') { choose I18n.t('registration.answer_yes') }
    within('.t-risk_profile_approach_question') { choose I18n.t('registration.risk_profile_approach_question.answers.bespoke') }
    within('.t-supplies_document_when_needed_question') { choose I18n.t('registration.answer_yes') }

    click_button I18n.t('travel_insurance_reregistrations.register_button')
  end

  def and_complete_the_medical_questions
    expect(page).to have_text('Step 3 of 4')

    within('.t-covers_medical_condition_question') { choose I18n.t('registration.covers_medical_condition_question.answers.one_specific') }

    click_button I18n.t('travel_insurance_reregistrations.register_button')
  end

  def then_the_firm_is_marked_for_reregistration
    expect(page).to have_text('Thank you for reregistering')

    @firm.reload

    expect(@firm).to be_reregistered_at
    expect(@firm).to be_confirmed_disclaimer
  end
end
