RSpec.feature 'Verify principal e-mail address' do
  let(:firms_page) { FirmsPage.new }

  before { Timecop.freeze(Time.local(1990)) }
  after { Timecop.return }

  scenario 'when the link in the confirmation e-mail is followed' do
    given_i_am_a_verified_principal
    when_i_follow_the_customised_link
    then_my_email_is_verified
    and_i_see_the_firms_page
  end

  def given_i_am_a_verified_principal
    @principal = FactoryGirl.create(:principal)
  end

  def when_i_follow_the_customised_link
    firms_page.load(query: {token: @principal.token})
  end

  def then_my_email_is_verified
    @principal.reload

    # We use the presence of a last sign-in date as an indication
    # that the principal's e-mail address is valid (they received
    # a link with their personal token in a confirmation e-mail).
    expect(@principal.last_sign_in_at).to eql(Time.now)
  end

  def and_i_see_the_firms_page
    expect(firms_page).to be_displayed
  end
end
