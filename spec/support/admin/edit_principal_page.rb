class Admin::EditPrincipalPage < SitePrism::Page
  set_url '/admin/retirement_principals/{principal_token}/edit'
  set_url_matcher %r{/admin/retirement_principals/[a-z0-9]+/edit}

  element :email_address, '.t-email-address'
  element :save, '.t-save'
end
