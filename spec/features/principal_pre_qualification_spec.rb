RSpec.feature 'Principal answers pre-qualification questions' do
  let(:pre_qualification_page) { PreQualificationPage.new }
  let(:identification_page) { IdentificationPage.new }
  let(:rejection_page) { RejectionPage.new }

  before do
    pre_qualification_page.load
  end

  scenario 'Answering all questions correctly' do
    given_i_answer_all_questions_yes
    then_i_am_able_to_proceed_to_verify_my_identity
  end

  scenario 'Answering any questions "No"' do
    given_i_answer_a_question_no
    then_i_am_notified_i_cannot_proceed
    and_i_am_able_to_send_a_message_to_the_administrator
    and_i_am_able_to_go_back_and_modify_my_answers
  end


  def given_i_answer_all_questions_yes
    pre_qualification_page.question_1.choose('Yes')
    pre_qualification_page.question_2.choose('Yes')
    pre_qualification_page.question_3.choose('Yes')
    pre_qualification_page.submit.click
  end

  def then_i_am_able_to_proceed_to_verify_my_identity
    expect(identification_page).to be_displayed
  end

  def given_i_answer_a_question_no
    pre_qualification_page.question_1.choose('Yes')
    pre_qualification_page.question_2.choose('Yes')
    pre_qualification_page.question_3.choose('No')
    pre_qualification_page.submit.click
  end

  def then_i_am_notified_i_cannot_proceed
    expect(rejection_page).to be_displayed
  end

  def and_i_am_able_to_send_a_message_to_the_administrator
    expect(rejection_page.administrator_message).to be_present
  end

  def and_i_am_able_to_go_back_and_modify_my_answers
    rejection_page.go_back.click
    expect(pre_qualification_page).to be_displayed
  end
end
