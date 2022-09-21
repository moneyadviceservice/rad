RSpec.feature 'Principal answers pre-qualification questions' do
  let(:pre_qualification_page) { PreQualificationPage.new }
  let(:identification_page) { IdentificationPage.new }
  let(:rejection_page) { RetirementAdviceRejectionPage.new }

  before do
    pre_qualification_page.load
  end

  scenario 'Submitting the blank form without answering anything' do
    when_i_submit_my_answers
    then_i_am_notified_i_cannot_proceed
  end

  scenario 'Answering all questions "Yes" and choosing "Independent"' do
    given_i_answer_all_questions_yes_and_choose_independent
    when_i_submit_my_answers
    then_i_am_able_to_proceed_to_verify_my_identity
  end

  scenario 'Answering any question "No"' do
    given_i_answer_a_question_no
    when_i_submit_my_answers
    then_i_am_notified_i_cannot_proceed
    and_i_am_able_to_send_a_message_to_the_administrator
  end

  def when_i_submit_my_answers
    pre_qualification_page.submit.click
  end

  def given_i_answer_all_questions_yes_and_choose_independent
    pre_qualification_page.active_question.choose('Yes')
    pre_qualification_page.business_model_question.choose('Yes')
    pre_qualification_page.status_question.choose('Independent')
  end

  def then_i_am_able_to_proceed_to_verify_my_identity
    expect(identification_page).to be_displayed
  end

  def given_i_answer_a_question_no
    pre_qualification_page.active_question.choose('Yes')
    pre_qualification_page.business_model_question.choose('No')
  end

  def then_i_am_notified_i_cannot_proceed
    expect(rejection_page).to be_displayed
  end

  def and_i_am_able_to_send_a_message_to_the_administrator
    expect(rejection_page.administrator_message).to be_present
  end
end
