class QuestionnairePage < SitePrism::Page
  set_url 'principals/{principal}/firm/questionnaire/edit'
  set_url_matcher %r{/principals/[a-f0-9]{8}/firm/questionnaire(/edit)?}

  element :firm_name, '.t-firm-name'
  element :firm_fca_number, '.t-firm-fca-number'

  element :email_address_field, '#firm_email_address'
  element :telephone_number_field, '#firm_telephone_number'
  element :address_line_1_field, '#firm_address_line_1'
  element :address_town_field, '#firm_address_town'
  element :address_county_field, '#firm_address_county'
  element :address_postcode_field, '#firm_address_postcode'

  elements :in_person_advice_method_checkboxes, '.t-questionnaire__in_person_advice_method_id'
  elements :other_advice_method_checkboxes, '.t-questionnaire__other_advice_method_id'
  element :offers_free_initial_meeting_radio_button, '#firm_free_initial_meeting_true'
  element :does_not_offer_free_initial_meeting_radio_button, '#firm_free_initial_meeting_false'
  elements :initial_meeting_duration_checkboxes, '.t-questionnaire__firm_initial_meeting_duration_id'
  elements :initial_fee_structure_checkboxes, '.t-questionnaire__initial_advice_fee_structure_id'
  elements :ongoing_fee_structure_checkboxes, '.t-questionnaire__ongoing_advice_fee_structure_id'
  elements :allowed_payment_method_checkboxes, '.t-questionnaire__allowed_payment_method_id'
  element :minimum_fee_field, '#firm_minimum_fixed_fee'

  element :firm_retirement_income_products_percent_field, '#firm_retirement_income_products_percent'
  element :firm_pension_transfer_percent_field, '#firm_pension_transfer_percent'
  element :firm_long_term_care_percent_field, '#firm_long_term_care_percent'
  element :firm_equity_release_percent_field, '#firm_equity_release_percent'
  element :firm_inheritance_tax_and_estate_planning_percent_field, '#firm_inheritance_tax_and_estate_planning_percent'
  element :firm_wills_and_probate_percent_field, '#firm_wills_and_probate_percent'
  element :firm_other_percent_field, '#firm_other_percent'

  elements :investment_size_checkboxes, '.t-questionnaire__firm_investment_size_id'

  element :next_button, '.l-questionnaire__button button'
end
