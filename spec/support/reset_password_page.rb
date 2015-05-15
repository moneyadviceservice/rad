class ResetPasswordPage < SitePrism::Page
  set_url '/users/password/edit'
  set_url_matcher %r{/users/password/edit?reset_password_token=.*}

  element :password_field, '#user_password'
  element :password_confirmation_field, '#user_password_confirmation'
  element :submit_button, '#new_user input[type="submit"]'
end
