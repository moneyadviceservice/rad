module Dashboard
  class DashboardPage < SitePrism::Page
    set_url '/dashboard'
    set_url_matcher %r{/dashboard}

    element :flash_message, '.t-flash-message'
    section :navigation, NavigationSection, '.t-navigation'
    sections :firms, DashboardListItemSection, '.t-firm-list-item'
    sections :trading_names, DashboardListItemSection, '.t-trading-name'
    element :view_all_firms_link, '.t-view-all-firms'
    sections :advisers, DashboardListItemSection, '.t-adviser'
  end
end
