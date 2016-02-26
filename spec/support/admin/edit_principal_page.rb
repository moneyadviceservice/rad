class Admin::EditPrincipalPage < SitePrism::Page
  set_url '/admin/principals/{principal_token}'
  set_url_matcher %r{/admin/principals/[a-z0-9]+}

  element :delete, '.t-delete'
end
