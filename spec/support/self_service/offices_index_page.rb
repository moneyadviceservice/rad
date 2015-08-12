module SelfService
  class OfficesIndexPage < SitePrism::Page
    set_url '/self_service/firms/{firm_id}/offices'
    set_url_matcher %r{/self_service/firms/\d+/offices}

    element :page_title, '.t-page-title'
    elements :offices, '.t-office-table-row'
  end
end
