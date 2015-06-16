module Dashboard
  class DashboardPage < SitePrism::Page
    set_url '/dashboard'
    set_url_matcher %r{/dashboard}

    element :flash_message, '.t-flash-message'
    section :navigation, NavigationSection, '.t-navigation'
    sections :firms, FirmListItemSection, '.t-firm-list-item'
    sections :trading_names, FirmListItemSection, '.t-trading-name'
    element :firm_count, '.t-firm-count'
    element :adviser_count, '.t-adviser-count'
    sections :advisers, AdviserListItemSection, '.t-adviser'
  end
end
