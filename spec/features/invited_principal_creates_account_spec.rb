RSpec.feature 'An invited principal can create a user account' do
  let(:accept_invitation_page) { AcceptInvitationPage.new }
  let(:firms_index_page) { SelfService::FirmsIndexPage.new }
  let(:password) { 'ABCabc123@£$' }

  scenario 'Principal accepts the invite and sets a password' do
    given_the_principal_exists
    when_they_are_invited_to_create_a_user_account
    then_they_receive_an_email_with_a_link_to_accept_the_invite

    when_they_click_the_link_to_accept_the_invitation
    then_they_are_on_the_accept_invitation_page

    when_they_set_the_password_inconsistently
    and_submit_the_form
    then_they_are_on_the_accept_invitation_page
    and_they_are_not_signed_in
    and_they_see_a_notice_that_there_were_validation_errors

    when_they_set_a_valid_password
    and_submit_the_form
    then_they_are_on_the_firms_index_page
    and_they_see_a_confirmation_message
    and_they_are_signed_in
  end

  def given_the_principal_exists
    @principal = FactoryGirl.create(:principal)
    @principal.firm = FactoryGirl.create(:firm, fca_number: @principal.fca_number)
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

  def when_they_set_the_password_inconsistently
    accept_invitation_page.password.set password
    accept_invitation_page.password_confirmation.set password.chop
  end

  def when_they_set_a_valid_password
    accept_invitation_page.password.set password
    accept_invitation_page.password_confirmation.set password
  end

  def and_submit_the_form
    accept_invitation_page.submit.click
  end

  def then_they_are_on_the_firms_index_page
    expect(firms_index_page).to be_displayed
  end

  def and_they_see_a_confirmation_message
    expect(firms_index_page)
      .to have_flash_message(text: I18n.t('devise.invitations.updated'))
  end

  def and_they_see_a_notice_that_there_were_validation_errors
    expect(accept_invitation_page).to have_devise_form_errors
  end

  def and_they_are_signed_in
    expect(@user.reload.sign_in_count).to eq(1)
    expect(firms_index_page.navigation).to have_sign_out
  end

  def and_they_are_not_signed_in
    expect(@user.reload.sign_in_count).to eq 0
    expect(firms_index_page.navigation).to have_sign_in
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
