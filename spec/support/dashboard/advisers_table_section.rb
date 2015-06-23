require_relative 'advisers_table_row_section'

module SelfService
  class AdvisersTableSection < SitePrism::Section
    sections :advisers, AdvisersTableRowSection, '.t-advisers-table-row'

    element :add_adviser_link, '.t-add-adviser-link'
    element :edit_link, '.t-edit-link'
    element :no_advisers_message, '.t-no-advisers-message'
  end
end
