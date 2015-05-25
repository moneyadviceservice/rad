module Dashboard
  class FirmListItemSection < SitePrism::Section
    element :type, '.t-firm-type'
    element :name, '.t-firm-name'
  end
end
