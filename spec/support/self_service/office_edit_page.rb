module SelfService
  class OfficeEditPage < SitePrism::Page
    set_url '/self_service/firms/{firm}/offices/{office}'
    set_url_matcher %r{/self_service/firms/\d+/offices/\d+}

    element :flash_message, '.t-flash-message'
    element :validation_summary, '.t-validation-summary'

    element :address_line_one, '.t-address-line-one'
    element :address_line_two, '.t-address-line-two'
    element :address_town, '.t-address-town'
    element :address_county, '.t-address-county'
    element :address_postcode, '.t-address-postcode'
    element :email_address, '.t-email-address'
    element :telephone_number, '.t-telephone-number'
    element :disabled_access, '.t-disabled-access'

    element :save_button, '.t-submit'
  end
end
