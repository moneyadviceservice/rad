class QuestionnairePage < SitePrism::Page
  set_url '/principals/{principal}/firms/{firm}/questionnaire/edit'
  set_url_matcher %r{/principals/[a-f0-9]{8}/firms/\d+/questionnaire(/edit)?}

  element :firm_name, '.t-firm-name'
  element :firm_fca_number, '.t-firm-fca-number'

  element :email_address, '#firm_email_address'
  element :telephone_number, '#firm_telephone_number'
  element :address_line_one, '#firm_address_line_one'
  element :address_town, '#firm_address_town'
  element :address_county, '#firm_address_county'
  element :address_postcode, '#firm_address_postcode'

  elements :in_person_advice_methods, '.t-questionnaire__in-person-advice-method-id'
  elements :other_advice_methods, '.t-questionnaire__other-advice-method-id'
  element :offers_free_initial_meeting, '#firm_free_initial_meeting_true'
  element :does_not_offer_free_initial_meeting, '#firm_free_initial_meeting_false'
  elements :initial_meeting_durations, '.t-questionnaire__firm-initial-meeting-duration-id'
  elements :initial_fee_structures, '.t-questionnaire__initial-advice-fee-structure-id'
  elements :ongoing_fee_structures, '.t-questionnaire__ongoing-advice-fee-structure-id'
  elements :allowed_payment_methods, '.t-questionnaire__allowed-payment-method-id'
  element :minimum_fee, '#firm_minimum_fixed_fee'

  element :retirement_income_products_flag, '#firm_retirement_income_products_flag'
  element :pension_transfer_flag, '#firm_pension_transfer_flag'
  element :long_term_care_flag, '#firm_long_term_care_flag'
  element :equity_release_flag, '#firm_equity_release_flag'
  element :inheritance_tax_and_estate_planning_flag, '#firm_inheritance_tax_and_estate_planning_flag'
  element :wills_and_probate_flag, '#firm_wills_and_probate_flag'

  elements :investment_sizes, '.t-questionnaire__firm-investment-size-id'

  element :next_button, '.l-questionnaire__button button'
end
