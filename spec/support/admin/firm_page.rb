class Admin::FirmPage < SitePrism::Page
  set_url '/admin/firms/{firm_id}'
  set_url_matcher %r{/admin/firms/[0-9]+}

  element :move_advisers, '.t-move-advisers'
  element :sign_in_as_principal, '.t-sign-in-as-principal'
end
