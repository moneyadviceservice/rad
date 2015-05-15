class ForgotPasswordPage < SitePrism::Page
  set_url '/users/password/new'
  set_url_matcher %r{/users/password/new}

  element :email_field, '#user_email'
  element :submit_button, '#new_user input[type="submit"]'
end
