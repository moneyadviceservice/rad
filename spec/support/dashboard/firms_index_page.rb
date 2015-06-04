module Dashboard
  class FirmsIndexPage < SitePrism::Page
    set_url '/dashboard/firms'
    set_url_matcher %r{/dashboard/firms}

    section :parent_firm, FirmTableRowSection, '.t-parent-firm-table-row'
    sections :trading_names, FirmTableRowSection, '.t-trading-name-table-row'
    sections :available_trading_names, FirmTableRowSection, '.t-available-trading-name-table-row'
  end
end
