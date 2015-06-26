module SelfService
  class FirmTableRowSection < SitePrism::Section
    element :frn, '.t-frn'
    element :name, '.t-firm-name'
    element :principal_name, '.t-principal-name'
    element :edit_link, '.t-edit-link'
    element :delete_button, '.t-remove-button'
  end
end
