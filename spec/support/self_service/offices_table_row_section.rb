module SelfService
  class OfficesTableRowSection < SitePrism::Section
    element :address, '.t-address'
    element :address_postcode, '.t-address-postcode'
    element :telephone_number, '.t-telephone-number'
    element :email_address, '.t-email-address'
    element :disabled_access, '.t-disabled-access'
  end
end
