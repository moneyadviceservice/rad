module SelfService
  class FirmEditPage < SitePrism::Page
    set_url '/self_service/firms/{firm}'
    set_url_matcher %r{/self_service/firms/\d+}

    element :flash_message, '.t-flash-message'
    element :validation_summary, '.t-validation-summary'

    element :firm_name, '.t-firm-name'
    element :firm_fca_number, '.t-firm-fca-number'

    element :website_address, '.t-website-address'

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

    element :retirement_income_products_flag, '.t-retirement-income-products-flag'
    element :pension_transfer_flag, '.t-pension-transfer-flag'
    element :long_term_care_flag, '.t-long-term-care-flag'
    element :equity_release_flag, '.t-equity-release-flag'
    element :inheritance_tax_and_estate_planning_flag, '.t-inheritance-tax-and-estate-planning-flag'
    element :wills_and_probate_flag, '.t-wills-and-probate-flag'

    element :ethical_investing_flag, '.t-ethical-investing-flag'
    element :sharia_investing_flag, '.t-sharia-investing-flag'

    element :status_restricted, '.t-status-restricted'
    element :status_independent, '.t-status-independent'

    elements :investment_sizes, '.t-questionnaire__firm-investment-size-id'

    elements :languages, '.t-languages'

    element :save_button, '.t-save-button'

    def offers_free_initial_meeting=(choice)
      send("offers_free_initial_meeting_#{choice}").set(true)
    end

    def offers_free_initial_meeting?
      !!offers_free_initial_meeting_true.checked?
    end

    def retirement_income_products_flag?
      !!retirement_income_products_flag.checked?
    end

    def pension_transfer_flag?
      !!pension_transfer_flag.checked?
    end

    def long_term_care_flag?
      !!long_term_care_flag.checked?
    end

    def equity_release_flag?
      !!equity_release_flag.checked?
    end

    def inheritance_tax_and_estate_planning_flag?
      !!inheritance_tax_and_estate_planning_flag.checked?
    end

    def wills_and_probate_flag?
      !!wills_and_probate_flag.checked?
    end

    def ethical_investing_flag?
      !!ethical_investing_flag.checked?
    end

    def sharia_investing_flag?
      !!sharia_investing_flag.checked?
    end

    def status
      return 'restricted' if status_restricted.checked?
      'independent'
    end

    def status=(status)
      status_restricted.set(true) if status == 'restricted'
      status_independent.set(true) if status == 'independent'
    end
  end
end
