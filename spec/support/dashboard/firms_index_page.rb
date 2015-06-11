module Dashboard
  class FirmsIndexPage < SitePrism::Page
    set_url '/dashboard/firms'
    set_url_matcher %r{/dashboard/firms}

    section :parent_firm, FirmTableRowSection, '.t-parent-firm-table-row'
    element :trading_names_block, '.t-trading-names-block'
    sections :trading_names, FirmTableRowSection, '.t-trading-name-table-row'
    element :available_trading_names_block, '.t-available-trading-names-block'
    sections :available_trading_names, FirmTableRowSection, '.t-available-trading-name-table-row'
  end
end
