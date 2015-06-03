module Dashboard
  class FirmEditPage < SitePrism::Page
    set_url '/dashboard/firms/{firm}'
    set_url_matcher %r{/dashboard/firms/\d+}

    element :flash_message, '.t-flash-message'
    element :validation_summary, '.t-validation-summary'

    element :firm_name, '.t-firm-name'
    element :firm_fca_number, '.t-firm-fca-number'

    element :email_address, '.t-email-address'
    element :telephone_number, '.t-telephone-number'
    element :address_line_one, '.t-address-line-one'
    element :address_town, '.t-address-town'
    element :address_county, '.t-address-county'
    element :address_postcode, '.t-address-postcode'

    elements :in_person_advice_methods, '.t-questionnaire__in-person-advice-method-id'
    elements :other_advice_methods, '.t-questionnaire__other-advice-method-id'
    element :offers_free_initial_meeting_true, '.t-free-initial-meeting-true'
    element :offers_free_initial_meeting_false, '.t-free-initial-meeting-false'
    element :does_not_offer_free_initial_meeting, '.t-free-initial-meeting-false'
    elements :initial_meeting_durations, '.t-questionnaire__firm-initial-meeting-duration-id'
    elements :initial_fee_structures, '.t-questionnaire__initial-advice-fee-structure-id'
    elements :ongoing_fee_structures, '.t-questionnaire__ongoing-advice-fee-structure-id'
    elements :allowed_payment_methods, '.t-questionnaire__allowed-payment-method-id'
    element :minimum_fee, '.t-minimum_fixed_fee'

    element :retirement_income_products_percent, '.t-retirement-income-products-percent'
    element :pension_transfer_percent, '.t-pension-transfer-percent'
    element :long_term_care_percent, '.t-long-term-care-percent'
    element :equity_release_percent, '.t-equity-release-percent'
    element :inheritance_tax_and_estate_planning_percent, '.t-inheritance-tax-and-estate-planning-percent'
    element :wills_and_probate_percent, '.t-wills-and-probate-percent'
    element :other_percent, '.t-other-percent'

    elements :investment_sizes, '.t-questionnaire__firm-investment-size-id'

    element :save_button, '.t-save-button'

    def offers_free_initial_meeting=(choice)
      send("offers_free_initial_meeting_#{choice}").set(true)
    end

    def offers_free_initial_meeting?
      !!offers_free_initial_meeting_true.checked?
    end
  end
end
