class ForgotPasswordPage < SitePrism::Page
  set_url '/users/password/new'
  set_url_matcher %r{/users/password/new}

  element :email_field, '.t-email-field'
  element :submit_button, '.t-submit-button'
end
