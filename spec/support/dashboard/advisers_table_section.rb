module Dashboard
  class AdvisersTableSection < SitePrism::Section
    sections :advisers, AdvisersTableRowSection, '.t-advisers-table-row'
  end
end
