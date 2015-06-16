module Dashboard
  class DashboardListItemSection < SitePrism::Section
    element :type, '.t-type'
    element :name, '.t-name'
  end
end
