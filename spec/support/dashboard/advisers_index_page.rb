module Dashboard
  class AdvisersIndexPage < SitePrism::Page
    set_url '/dashboard/advisers'
    set_url_matcher %r{/dashboard/advisers}

    section :parent_firm, AdvisersTableSection, '.t-parent-firm'
    sections :trading_names, AdvisersTableSection, '.t-trading-name'
  end
end
