module SelfService
  class OfficesTableRowSection < SitePrism::Section
    element :address, '.t-address'
    element :address_postcode, '.t-address-postcode'
    element :telephone_number, '.t-telephone-number'
    element :email_address, '.t-email-address'
    element :disabled_access, '.t-disabled-access'
    element :main_firm, '.t-main-office'
    element :delete_button, '.t-delete-button'
    element :edit_link, '.t-edit-link'

    def the_main_office?
      main_firm.present?
    rescue
      false
    end
  end
end
