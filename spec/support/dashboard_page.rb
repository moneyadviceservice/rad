class DashboardPage < SitePrism::Page
  set_url '/dashboard'
  set_url_matcher %r{/dashboard}

  sections :firms, FirmListItemSection, '.t-firm-list-item'
  sections :trading_names, FirmListItemSection, '.t-trading-name'
  element :firm_count, '.t-firm-count'
end
