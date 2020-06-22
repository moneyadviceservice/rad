module SelfService
  module TravelInsuranceFirms
    class OfficeEditPage < SitePrism::Page
      set_url '/self_service/travel_insurance_firms/{firm}/offices/{office}/edit'
      set_url_matcher %r{/self_service/travel_insurance_firms/\d+/offices/\d+/edit}

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

      element :weekday_opening_time, '.t-weekday-opening-time'
      element :weekday_closing_time, '.t-weekday-closing-time'

      element :open_saturday, '.t-open-saturday'
      element :closed_saturday, '.t-closed-saturday'
      element :saturday_opening_time, '.t-saturday-opening-time'
      element :saturday_closing_time, '.t-saturday-closing-time'

      element :open_sunday, '.t-open-sunday'
      element :closed_sunday, '.t-closed-sunday'
      element :sunday_opening_time, '.t-sunday-opening-time'
      element :sunday_closing_time, '.t-sunday-closing-time'

      element :save_button, '.t-submit'
    end
  end
end
