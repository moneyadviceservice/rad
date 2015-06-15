module Dashboard
  class AdvisersTableSection < SitePrism::Section
    sections :advisers, AdvisersTableRowSection, '.t-advisers-table-row'

    element :edit_link, '.t-edit-link'
  end
end
