module SelfService
  class OfficesIndexPage < SitePrism::Page
    set_url '/self_service/firms/{firm_id}/offices'
    set_url_matcher %r{/self_service/firms/\d+/offices}
  end
end
