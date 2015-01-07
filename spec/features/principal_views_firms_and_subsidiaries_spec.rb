RSpec.feature 'Principal views Firms and Subsidiaries' do
  let(:firm_page) { FirmPage.new }
  let(:questionnaire_page) { QuestionnairePage.new }

  scenario 'My Firm has no Subsidiaries' do
    given_i_am_verified
    when_i_follow_my_email_verification_link
    then_i_am_directed_to_the_questionnaire_for_my_firm
  end


  def given_i_am_verified
    @principal = create(:principal)
  end

  def when_i_follow_my_email_verification_link
    firm_page.load(principal: @principal.token)
  end

  def then_i_am_directed_to_the_questionnaire_for_my_firm
    expect(questionnaire_page).to be_displayed
  end
end
