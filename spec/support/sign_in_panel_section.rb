class SignInPanelSection < SitePrism::Section
  element :login_field, '.t-login-field'
  element :password_field, '.t-password-field'
  element :submit_button, '.t-sign-in-button'
  element :forgot_password_link, '.t-forgot-password'
end
