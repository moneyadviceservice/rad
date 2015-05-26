RSpec.feature 'Principal can sign in' do
  let(:sign_in_page) { SignInPage.new }

  scenario 'Principal can sign in with correct details' do
    given_the_principal_user_exists
    when_they_sign_in_with_correct_details
    they_have_logged_in
    they_see_the_index_page
  end

  scenario 'Principal cannot sign in with incorrect details' do
    given_the_principal_user_exists
    when_they_sign_in_with_incorrect_details
    they_have_not_logged_in
    they_see_the_sign_in_page
  end

  def given_the_principal_user_exists
    @user = FactoryGirl.create(:user)
  end

  def when_they_sign_in_with_correct_details
    visit new_user_session_path
    sign_in_page.email_field.set @user.email
    sign_in_page.password_field.set 'Password1!'
    sign_in_page.submit_button.click
  end

  def when_they_sign_in_with_incorrect_details
    visit new_user_session_path
    sign_in_page.email_field.set @user.email
    sign_in_page.password_field.set 'not_a_password'
    sign_in_page.submit_button.click
  end

  def they_have_logged_in
    # TODO: We don't have access to `current_user` in feature
    # tests, so we'll rely on this? Until we can test it on content.
    expect(@user.reload.sign_in_count).to eq 1
  end

  def they_have_not_logged_in
    expect(@user.reload.sign_in_count).to eq 0
  end

  def they_see_the_index_page
    expect(page.current_path).to eq root_path
  end

  def they_see_the_sign_in_page
    expect(page.current_path).to eq new_user_session_path
  end

end
