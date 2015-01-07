RSpec.feature 'Verify principal e-mail address' do
  let(:firm_page) { FirmPage.new }

  before { Timecop.freeze(Time.local(1990)) }
  after { Timecop.return }

  scenario 'when the link in the confirmation e-mail is followed' do
    given_i_am_a_verified_principal
    when_i_follow_the_customised_link
    then_i_see_the_firm_page
  end

  def given_i_am_a_verified_principal
    @principal = create(:principal)
  end

  def when_i_follow_the_customised_link
    firm_page.load(principal: @principal.token)
  end

  def then_i_see_the_firm_page
    expect(firm_page).to be_displayed
  end
end
