RSpec.feature 'Principal can sign in using the embedded sign in panel' do
  let(:panel_host_page) { RootPage.new }
  let(:sign_in_page) { SignInPage.new }
  let(:after_signin_page) { SelfService::FirmsIndexPage.new }
  let(:forgot_password_page) { ForgotPasswordPage.new }

  before do
    panel_host_page.load
  end

  scenario 'Principal can sign in with FRN and password' do
    given_the_principal_user_exists
    when_they_sign_in_with_frn_and_password
    they_see_the_after_signin_page
    they_have_logged_in
  end

  scenario 'Principal cannot sign in with incorrect details' do
    given_the_principal_user_exists
    when_they_sign_in_with_incorrect_details
    they_have_not_logged_in
    they_see_the_sign_in_page
    and_they_see_a_notice_that_their_details_were_incorrect
  end

  scenario 'Principal clicks the forgotten password link' do
    when_the_principal_clicks_the_forgotten_password_link
    then_they_see_the_forgotten_password_page
  end

  def given_the_principal_user_exists
    @user = FactoryGirl.create(:user)
  end

  def when_they_sign_in_with_frn_and_password
    panel_host_page.sign_in_panel.login_field.set @user.principal.fca_number
    panel_host_page.sign_in_panel.password_field.set 'Password1!'
    panel_host_page.sign_in_panel.submit_button.click
  end

  def when_they_sign_in_with_incorrect_details
    panel_host_page.sign_in_panel.login_field.set @user.email
    panel_host_page.sign_in_panel.password_field.set 'not_a_password'
    panel_host_page.sign_in_panel.submit_button.click
  end

  def they_have_logged_in
    expect(@user.reload.sign_in_count).to eq 1
    expect(after_signin_page.navigation).to have_sign_out
  end

  def they_have_not_logged_in
    expect(@user.reload.sign_in_count).to eq 0
    expect(after_signin_page.navigation).to have_sign_in
  end

  def they_see_the_after_signin_page
    expect(after_signin_page).to be_displayed
  end

  def they_see_the_sign_in_page
    expect(sign_in_page).to be_displayed
  end

  def and_they_see_a_notice_that_their_details_were_incorrect
    expect(sign_in_page.devise_form_errors).to have_text(
      I18n.t('devise.failure.invalid', authentication_keys: 'login'))
  end

  def when_the_principal_clicks_the_forgotten_password_link
    panel_host_page.sign_in_panel.forgot_password_link.click
  end

  def then_they_see_the_forgotten_password_page
    expect(forgot_password_page).to be_displayed
  end
end
