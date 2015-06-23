module SelfService
  class NavigationSection < SitePrism::Section
    elements :dashboard_links, '.t-dashboard-link'
    element :sign_out, '.t-sign-out'
    element :sign_in, '.t-sign-in'
  end
end
