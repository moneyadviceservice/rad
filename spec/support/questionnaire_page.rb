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

  elements :in_person_advice_methods, '.t-questionnaire__in_person_advice_method_id'
  elements :other_advice_methods, '.t-questionnaire__other_advice_method_id'
  element :offers_free_initial_meeting, '#firm_free_initial_meeting_true'
  element :does_not_offer_free_initial_meeting, '#firm_free_initial_meeting_false'
  elements :initial_meeting_durations, '.t-questionnaire__firm_initial_meeting_duration_id'
  elements :initial_fee_structures, '.t-questionnaire__initial_advice_fee_structure_id'
  elements :ongoing_fee_structures, '.t-questionnaire__ongoing_advice_fee_structure_id'
  elements :allowed_payment_methods, '.t-questionnaire__allowed_payment_method_id'
  element :minimum_fee, '#firm_minimum_fixed_fee'

  element :retirement_income_products_percent, '#firm_retirement_income_products_percent'
  element :pension_transfer_percent, '#firm_pension_transfer_percent'
  element :long_term_care_percent, '#firm_long_term_care_percent'
  element :equity_release_percent, '#firm_equity_release_percent'
  element :inheritance_tax_and_estate_planning_percent, '#firm_inheritance_tax_and_estate_planning_percent'
  element :wills_and_probate_percent, '#firm_wills_and_probate_percent'
  element :other_percent, '#firm_other_percent'

  elements :investment_sizes, '.t-questionnaire__firm_investment_size_id'

  element :next_button, '.l-questionnaire__button button'
end
