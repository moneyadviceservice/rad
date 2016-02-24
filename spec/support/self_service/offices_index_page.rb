require_relative './offices_table_row_section'

module SelfService
  class OfficesIndexPage < SitePrism::Page
    set_url '/self_service/firms/{firm_id}/offices'
    set_url_matcher %r{/self_service/firms/\d+/offices}

    element :page_title, '.t-firm-name'
    sections :offices, OfficesTableRowSection, '.t-office-table-row'
    element :add_office_link, '.t-add-office-link'
    element :no_offices_message, '.t-no-offices-message'
    element :flash_message, '.t-flash-message'
  end
end
