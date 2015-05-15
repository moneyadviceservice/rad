class ResetPasswordPage < SitePrism::Page
  set_url '/users/password/edit'
  set_url_matcher %r{/users/password/edit?reset_password_token=.*}

  element :password_field, '.t-password-field'
  element :password_confirmation_field, '.t-password-confirmation-field'
  element :submit_button, '.t-submit-button'
end
