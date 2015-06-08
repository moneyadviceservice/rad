RSpec.feature 'An invited principal can create a user account' do
  let(:accept_invitation_page) { AcceptInvitationPage.new }
  let(:dashboard_page) { Dashboard::DashboardPage.new }

  scenario 'Principal accepts the invite and sets a password' do
    given_the_principal_exists
    when_they_are_invited_to_create_a_user_account
    then_they_receive_an_email_with_a_link_to_accept_the_invite

    when_they_click_the_link_to_accept_the_invitation
    then_they_are_on_the_accept_invitation_page

    when_they_set_a_password
    and_submit_the_form
    then_they_are_on_the_dashboard_page
    and_they_see_a_confirmation_message
    and_they_are_signed_in
  end

  def given_the_principal_exists
    @principal = FactoryGirl.create(:principal)
  end

  def when_they_are_invited_to_create_a_user_account
    @user = User.invite!(principal_token: @principal.token,
                         email: @principal.email_address)
  end

  def then_they_receive_an_email_with_a_link_to_accept_the_invite
    expect(accept_user_invitation_url_from_email).to include(
      accept_invitation_page.url(invitation_token: @user.raw_invitation_token))
  end

  def when_they_click_the_link_to_accept_the_invitation
    accept_invitation_page.load(invitation_token: @user.raw_invitation_token)
  end

  def then_they_are_on_the_accept_invitation_page
    expect(accept_invitation_page).to be_displayed
    expect(accept_invitation_page).to have_password
    expect(accept_invitation_page).to have_password_confirmation
  end

  def when_they_set_a_password
    accept_invitation_page.password.set 'ABCabc123@£$'
    accept_invitation_page.password_confirmation.set 'ABCabc123@£$'
  end

  def and_submit_the_form
    accept_invitation_page.submit.click
  end

  def then_they_are_on_the_dashboard_page
    expect(dashboard_page).to be_displayed
  end

  def and_they_see_a_confirmation_message
    expect(dashboard_page)
      .to have_flash_message(text: I18n.t('devise.invitations.updated'))
  end

  def and_they_are_signed_in
    expect(@user.reload.sign_in_count).to eq(1)
    expect(dashboard_page.navigation).to have_sign_out
  end

  private

  def last_email_body
    ActionMailer::Base.deliveries.last.body.to_s
  end

  def accept_user_invitation_url_from_email
    Oga.parse_html(last_email_body)
      .at_css('.t-accept-invitation-url')
      .get(:href)
  end
end
