module SelfService
  class AdvisersIndexPage < SitePrism::Page
    set_url '/self_service/firms/{firm_id}/advisers'
    set_url_matcher %r{/self_service/firms/\d+/advisers}

    element :firm_name, '.t-firm-name'

    sections :advisers, AdvisersTableRowSection, '.t-advisers-table-row'

    element :add_adviser_link, '.t-add-adviser-link'
    element :edit_link, '.t-edit-link'
    element :no_advisers_message, '.t-no-advisers-message'
  end
end
