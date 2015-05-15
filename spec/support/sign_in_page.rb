class SignInPage < SitePrism::Page
  set_url '/users/sign_in'
  set_url_matcher %r{/users/sign_in}

  element :email_field, '#user_email'
  element :password_field, '#user_password'
  element :submit_button, '#new_user input[type="submit"]'
  element :forgot_password_link, '.t-forgot-password'
  element :flash_message, '.t-flash-message'
end
