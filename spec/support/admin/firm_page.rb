class Admin::FirmPage < SitePrism::Page
  set_url '/admin/retirement_firms/{firm_id}'
  set_url_matcher %r{/admin/retirement_firms/[0-9]+}

  elements :advisers, '.t-adviser'

  element :move_advisers, '.t-move-advisers'
  element :sign_in_as_principal, '.t-sign-in-as-principal'
  element :new_adviser, '.t-new-adviser'
  element :approved, 'p:contains("Approved:")'
  element :approve_button, 'input[value="Approve Firm"]'
  element :hide_button, 'input[value="Hide Firm"]'
  element :unhide_button, 'input[value="Unhide Firm"]'
  element :hidden, 'p:contains("Hidden:")'
end
