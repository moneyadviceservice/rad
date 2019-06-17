class Admin::FirmPage < SitePrism::Page
  set_url '/admin/firms/{firm_id}'
  set_url_matcher %r{/admin/firms/[0-9]+}

  elements :advisers, '.t-adviser'

  element :move_advisers, '.t-move-advisers'
  element :sign_in_as_principal, '.t-sign-in-as-principal'
  element :new_adviser, '.t-new-adviser'
  element :approved, 'p:contains("Approved:")'
  element :approve_button, 'input[value="Approve Firm"]'
  element :fca_not_verified_warning, '.alert-warning'
  element :verify_fca_reference_button, 'input[value="Verify FCA reference"]'
end
