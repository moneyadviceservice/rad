class DashboardPage < SitePrism::Page
  set_url '/dashboard'
  set_url_matcher %r{/dashboard}

  element :firms, '.t-dashboard-firms'
end
