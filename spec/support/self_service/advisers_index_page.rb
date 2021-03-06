module SelfService
  class AdvisersIndexPage < SitePrism::Page
    set_url '/self_service/firms/{firm_id}/advisers'
    set_url_matcher %r{/self_service/firms/\d+/advisers}

    element :back_to_firms_list_link, '.t-back-to-firm-list a'
    element :firm_name, '.t-firm-name'
    element :overall_status_panel, '.t-overall-status-panel'
    sections :advisers, AdvisersTableRowSection, '.t-advisers-table-row'
    element :add_adviser_link, '.t-add-adviser-link'
    element :edit_link, '.t-edit-link'
    element :no_advisers_message, '.t-no-advisers-message'
    element :flash_message, '.t-flash-message'
  end
end
