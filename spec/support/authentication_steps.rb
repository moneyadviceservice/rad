module AuthenticationSteps
  def and_i_sign_in(user)
    sign_in_page = SignInPage.new
    sign_in_page.load
    sign_in_page.email_field.set user.email
    sign_in_page.password_field.set 'Password1!'
    sign_in_page.submit_button.click
  end
end
