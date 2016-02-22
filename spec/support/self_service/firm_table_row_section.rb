module SelfService
  class FirmTableRowSection < SitePrism::Section
    element :frn, '.t-frn'
    element :name, '.t-firm-name'
    element :principal_name, '.t-principal-name'
    element :edit_link, '.t-edit-link'
    element :remove_button, '.t-remove-button'
    element :overall_status, '.t-overall-status'
    element :unpublished, '.status__overall-status--unpublished'
  end
end
