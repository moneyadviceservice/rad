class ChangePasswordPage < SitePrism::Page
  set_url '/users/edit'

  element :new_password, '.t-password'
  element :confirm_new_password, '.t-password-confirmation'
  element :current_password, '.t-current-password'
  element :submit, '.t-submit'
end
