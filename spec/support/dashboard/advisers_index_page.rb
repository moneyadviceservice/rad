module SelfService
  class AdvisersIndexPage < SitePrism::Page
    set_url '/self_service/advisers'
    set_url_matcher %r{/self_service/advisers}

    section :parent_firm, AdvisersTableSection, '.t-parent-firm'
    sections :trading_names, AdvisersTableSection, '.t-trading-name'
  end
end
