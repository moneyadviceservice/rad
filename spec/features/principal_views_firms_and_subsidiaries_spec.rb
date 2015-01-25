RSpec.feature 'Principal views Firms and Subsidiaries' do
  let(:firm_page) { FirmPage.new }
  let(:questionnaire_page) { QuestionnairePage.new }

  scenario 'My Firm has no Subsidiaries' do
    given_i_am_verified
    when_i_follow_my_email_verification_link
    then_i_am_directed_to_the_questionnaire_for_my_firm
  end

  scenario 'My Firm has Subsidiaries' do
    given_i_am_verified
    and_my_firm_has_associated_subsidiaries
    when_i_follow_my_email_verification_link
    then_i_am_shown_my_firm_and_its_subsidiaries
    and_i_can_choose_a_firm_or_subsidiary_questionnaire_to_complete
    when_i_choose_the_first_subsidiary
    then_the_subsidiary_is_created
    and_i_am_directed_to_the_questionnaire_for_my_subsidiary
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

  def and_my_firm_has_associated_subsidiaries
    Lookup::Firm.find_by(fca_number: @principal.fca_number).tap do |f|
      f.subsidiaries.create(name: 'Another Company PLC')
      f.subsidiaries.create(name: 'Bodgit and Leggit')
    end
  end

  def then_i_am_shown_my_firm_and_its_subsidiaries
    expect(firm_page.firm_title).to be_present
    expect(firm_page.subsidiaries).to be_present
  end

  def and_i_can_choose_a_firm_or_subsidiary_questionnaire_to_complete
    expect(firm_page.firm_questionnaire).to be_present
    expect(firm_page.subsidiary_questionnaires).to be_present
  end

  def when_i_choose_the_first_subsidiary
    firm_page.subsidiary_questionnaires.first.click
  end

  def then_the_subsidiary_is_created
    expect(@principal.firm.subsidiaries).to_not be_empty
  end

  def and_i_am_directed_to_the_questionnaire_for_my_subsidiary
    expect(questionnaire_page.firm_name.text).to eql('Another Company PLC')
  end
end
