class Admin::EditPrincipalPage < SitePrism::Page
  set_url '/admin/principals/{principal_token}/edit'
  set_url_matcher %r{/admin/principals/[a-z0-9]+/edit}

  element :email_address, '.t-email-address'
  element :save, '.t-save'
end
