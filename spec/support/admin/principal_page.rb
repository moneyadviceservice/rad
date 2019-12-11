class Admin::PrincipalPage < SitePrism::Page
  set_url '/admin/retirement_principals/{principal_token}'
  set_url_matcher %r{/admin/retirement_principals/[a-z0-9]+}

  element :edit_directory_information, '.t-edit-principal'
  element :edit_login_credentials, '.t-edit-user'
  element :delete, '.t-delete'
end
