RSpec.feature 'Verify principal e-mail address' do
  let(:firms_page) { FirmsPage.new }

  before { Timecop.freeze(Time.local(1990)) }
  after { Timecop.return }

  scenario 'when the link in the confirmation e-mail is followed' do
    given_i_am_a_verified_principal
    when_i_follow_the_customised_link
    then_i_see_the_firms_page
  end

  def given_i_am_a_verified_principal
    @principal = create(:principal)
  end

  def when_i_follow_the_customised_link
    firms_page.load(principal: @principal.token)
  end

  def then_i_see_the_firms_page
    expect(firms_page).to be_displayed
  end
end
