RSpec.feature 'Principal can reset their password' do
  let(:forgot_password_page) { ForgotPasswordPage.new }
  let(:reset_password_page) { ResetPasswordPage.new }
  let(:sign_in_page) { SignInPage.new }
  let(:firms_index_page) { SelfService::FirmsIndexPage.new }

  scenario 'Principal can request a password reset' do
    given_the_principal_user_exists
    when_they_visit_the_sign_in_page
    and_they_click_the_forgot_password_link
    and_they_submit_their_email
    then_they_see_a_confirmation_message
    and_get_an_email_with_a_reset_password_link
  end

  scenario 'Principal can reset password with link' do
    given_the_principal_user_exists
    and_they_have_requested_a_password_reset
    when_they_visit_their_reset_password_link
    and_they_submit_a_new_password_correctly
    then_they_see_a_reset_password_confirmation_message

    when_they_sign_out
    and_sign_in_with_new_details
    then_they_are_signed_in
  end

  def given_the_principal_user_exists
    @user = FactoryBot.create(:user)
  end

  def when_they_visit_the_sign_in_page
    sign_in_page.load
  end

  def and_they_click_the_forgot_password_link
    sign_in_page.forgot_password_link.click
  end

  def and_they_submit_their_email
    forgot_password_page.email_field.set @user.email
    forgot_password_page.submit_button.click
  end

  def then_they_see_a_confirmation_message
    message = I18n.t('devise.passwords.send_instructions')
    expect(sign_in_page).to have_flash_message(text: message)
  end

  def and_get_an_email_with_a_reset_password_link
    expect(last_email.body.to_s).to include '/users/password/edit?reset_password_token='
  end

  def and_they_have_requested_a_password_reset
    when_they_visit_the_sign_in_page
    and_they_click_the_forgot_password_link
    and_they_submit_their_email
  end

  def when_they_visit_their_reset_password_link
    visit reset_password_url_from_email
  end

  def and_they_submit_a_new_password_correctly
    reset_password_page.password_field.set 'new_Password1!'
    reset_password_page.password_confirmation_field.set 'new_Password1!'
    reset_password_page.submit_button.click
  end

  def then_they_see_a_reset_password_confirmation_message
    expect(firms_index_page).to have_flash_message(text: I18n.t('devise.passwords.updated'))
  end

  def then_they_are_signed_in
    expect(firms_index_page).to have_flash_message(text: I18n.t('devise.sessions.signed_in'))
  end

  def when_they_sign_out
    logout(scope: :user)
  end

  def and_sign_in_with_new_details
    sign_in_page.load
    sign_in_page.login_field.set @user.principal.fca_number
    sign_in_page.password_field.set 'new_Password1!'
    sign_in_page.submit_button.click
  end

  private

  def last_email
    ActionMailer::Base.deliveries.last
  end

  def reset_password_url_from_email
    Oga.parse_html(last_email.body.to_s)
      .at_css('.t-reset-password-link')
      .get(:href)
  end

  def reset_cookies
    Capybara.current_session.driver.browser.clear_cookies
  end
end
