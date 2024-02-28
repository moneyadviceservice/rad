RSpec.feature 'Principal can sign in' do
  let(:change_password_page) { ChangePasswordPage.new }
  let(:sign_in_page) { SignInPage.new }
  let(:firms_index_page) { SelfService::FirmsIndexPage.new }

  scenario 'Principal is signed out after changing their password' do
    given_the_principal_user_exists
    when_they_sign_in_with_frn_and_password
    and_they_change_their_password
    then_they_are_signed_out
  end

  scenario 'Principal can sign in with FRN and password' do
    given_the_principal_user_exists
    when_they_sign_in_with_frn_and_password
    they_see_the_firms_index_page
    they_have_logged_in
  end

  scenario 'Principal cannot sign in with email' do
    given_the_principal_user_exists
    when_they_sign_in_with_email_and_password
    they_have_not_logged_in
    they_see_the_sign_in_page
    and_they_see_a_notice_that_their_details_were_incorrect
  end

  scenario 'Principal cannot sign in with incorrect details' do
    given_the_principal_user_exists
    when_they_sign_in_with_incorrect_details
    they_have_not_logged_in
    they_see_the_sign_in_page
    and_they_see_a_notice_that_their_details_were_incorrect
  end

  def and_they_change_their_password
    change_password_page.load
    change_password_page.new_password.set 'Abcdefg123456789!{}|'
    change_password_page.confirm_new_password.set 'Abcdefg123456789!{}|'
    change_password_page.current_password.set 'Password1!'
    change_password_page.submit.click
  end

  def then_they_are_signed_out
    expect(sign_in_page).to be_loaded
  end

  def given_the_principal_user_exists
    @user = FactoryBot.create(:user)
  end

  def when_they_sign_in_with_email_and_password
    sign_in_page.load
    sign_in_page.login_field.set @user.email
    sign_in_page.password_field.set 'Password1!'
    sign_in_page.submit_button.click
  end

  def when_they_sign_in_with_frn_and_password
    sign_in_page.load
    sign_in_page.login_field.set @user.principal.fca_number
    sign_in_page.password_field.set 'Password1!'
    sign_in_page.submit_button.click
  end

  def when_they_sign_in_with_incorrect_details
    sign_in_page.load
    sign_in_page.login_field.set @user.email
    sign_in_page.password_field.set 'not_a_password'
    sign_in_page.submit_button.click
  end

  def they_have_logged_in
    expect(@user.reload.sign_in_count).to eq 1
    expect(firms_index_page.navigation).to have_sign_out
  end

  def they_have_not_logged_in
    expect(@user.reload.sign_in_count).to eq 0
    expect(firms_index_page.navigation).to have_sign_in
  end

  def they_see_the_firms_index_page
    expect(firms_index_page).to be_displayed
  end

  def they_see_the_sign_in_page
    expect(sign_in_page).to be_displayed
  end

  def and_they_see_a_notice_that_their_details_were_incorrect
    expect(sign_in_page.devise_form_errors).to have_text(
      I18n.t(
        'devise.failure.invalid',
        authentication_keys: 'Firm Reference Number'
      )
    )
  end
end
