module SelfService
  class AdvisersIndexPage < SitePrism::Page
    set_url '/selfservice/advisers'
    set_url_matcher %r{/selfservice/advisers}

    section :parent_firm, AdvisersTableSection, '.t-parent-firm'
    sections :trading_names, AdvisersTableSection, '.t-trading-name'
  end
end
