class SignInPage < SitePrism::Page
  set_url '/users/sign_in'
  set_url_matcher %r{/users/sign_in}

  element :login_field, '.t-login-field'
  element :password_field, '.t-password-field'
  element :submit_button, '.t-submit-button'
  element :forgot_password_link, '.t-forgot-password'
  element :flash_message, '.t-flash-message'
  element :devise_form_errors, '.t-devise-form-errors'
end
