class Admin::EditPrincipalUserPage < SitePrism::Page
  set_url '/admin/retirement_principals/{principal_token}/user/edit'
  set_url_matcher %r{/admin/retirement_principals/[a-z0-9]+/user/edit}

  element :email_address, '.t-email-address'
  element :password, '.t-password'
  element :password_confirmation, '.t-password-confirmation'
  element :save, '.t-save'
end
