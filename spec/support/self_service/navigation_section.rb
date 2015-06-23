module SelfService
  class NavigationSection < SitePrism::Section
    elements :navigation_links, '.t-navigation-link'
    element :sign_out, '.t-sign-out'
    element :sign_in, '.t-sign-in'
  end
end
