RSpec.feature 'Principal answers pre-qualification questions' do
  let(:pre_qualification_page) { PreQualificationPage.new }
  let(:identification_page) { IdentificationPage.new }

  before do
    pre_qualification_page.load
  end

  scenario 'Answering all questions correctly' do
    given_i_answer_all_questions_yes
    then_i_am_able_to_proceed_to_verify_my_identity
  end

  scenario 'Answering any questions "No"' do
    given_i_answer_a_question_no
    then_i_am_immediately_notified_i_cannot_proceed
    and_i_am_able_to_modify_my_original_answer
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

  def then_i_am_immediately_notified_i_cannot_proceed
    expect(pre_qualification_page).to have_error_message
  end

  def and_i_am_able_to_modify_my_original_answer
    expect(pre_qualification_page).to be_displayed
  end
end
