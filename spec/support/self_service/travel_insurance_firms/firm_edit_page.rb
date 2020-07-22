module SelfService
  module TravelInsuranceFirms
    class FirmEditPage < SitePrism::Page
      set_url '/self_service/travel_insurance_firms/{firm}/edit'
      set_url_matcher %r{/self_service/travel_insurance_firms/\d+}

      element :flash_message, '.t-flash-message'
      element :validation_summary, '.t-validation-summary'

      element :back_to_firms_list_link, '.t-back-to-firm-list a'
      element :firm_name, '.t-firm-name'

      # Tab buttons
      element :europe_tab_link, '.t-europe-link'
      element :worldwide_excluding_us_tab_link, '.t-worldwide-excluding-us-link'
      element :worldwide_including_us_tab_link, '.t-worldwide-including-us-link'

      # Tab status
      element :europe_tab_status, '.t-europe-link .t-tab-status'
      element :worldwide_excluding_us_tab_status, '.t-worldwide-excluding-us-link .t-tab-status'
      element :worldwide_including_us_tab_status, '.t-worldwide-including-us-link .t-tab-status'

      # Tabs content
      element :europe_tab, '.t-europe'
      element :worldwide_excluding_us_tab, '.t-worldwide-excluding-us'
      element :worldwide_including_us_tab, '.t-worldwide-including-us'

      # Age + location cover select
      element :single_europe_30_days_land, '.t-single-europe .t-one-month-land'
      element :single_europe_30_days_cruise, '.t-single-europe .t-one-month-cruise'
      element :single_europe_45_days_land, '.t-single-europe .t-six-month-land'
      element :single_europe_45_days_cruise, '.t-single-europe .t-six-month-cruise'
      element :single_europe_55_days_land, '.t-single-europe .t-six-month-plus-land'
      element :single_europe_55_days_cruise, '.t-single-europe .t-six-month-plus-cruise'

      element :annual_europe_30_days_land, '.t-annual-europe .t-one-month-land'
      element :annual_europe_30_days_cruise, '.t-annual-europe .t-one-month-cruise'
      element :annual_europe_45_days_land, '.t-annual-europe .t-six-month-land'
      element :annual_europe_45_days_cruise, '.t-annual-europe .t-six-month-cruise'
      element :annual_europe_55_days_land, '.t-annual-europe .t-six-month-plus-land'
      element :annual_europe_55_days_cruise, '.t-annual-europe .t-six-month-plus-cruise'

      # Worldwide excluding US
      element :single_worldwide_excluding_us_30_days_land, '.t-single-worldwide-excluding-us .t-one-month-land'
      element :single_worldwide_excluding_us_30_days_cruise, '.t-single-worldwide-excluding-us .t-one-month-cruise'
      element :single_worldwide_excluding_us_45_days_land, '.t-single-worldwide-excluding-us .t-six-month-land'
      element :single_worldwide_excluding_us_45_days_cruise, '.t-single-worldwide-excluding-us .t-six-month-cruise'
      element :single_worldwide_excluding_us_55_days_land, '.t-single-worldwide-excluding-us .t-six-month-plus-land'
      element :single_worldwide_excluding_us_55_days_cruise, '.t-single-worldwide-excluding-us .t-six-month-plus-cruise'

      element :annual_worldwide_excluding_us_30_days_land, '.t-annual-worldwide-excluding-us .t-one-month-land'
      element :annual_worldwide_excluding_us_30_days_cruise, '.t-annual-worldwide-excluding-us .t-one-month-cruise'
      element :annual_worldwide_excluding_us_45_days_land, '.t-annual-worldwide-excluding-us .t-six-month-land'
      element :annual_worldwide_excluding_us_45_days_cruise, '.t-annual-worldwide-excluding-us .t-six-month-cruise'
      element :annual_worldwide_excluding_us_55_days_land, '.t-annual-worldwide-excluding-us .t-six-month-plus-land'
      element :annual_worldwide_excluding_us_55_days_cruise, '.t-annual-worldwide-excluding-us .t-six-month-plus-cruise'

      # Worldwide including US
      element :single_worldwide_including_us_30_days_land, '.t-single-worldwide-including-us .t-one-month-land'
      element :single_worldwide_including_us_30_days_cruise, '.t-single-worldwide-including-us .t-one-month-cruise'
      element :single_worldwide_including_us_45_days_land, '.t-single-worldwide-including-us .t-six-month-land'
      element :single_worldwide_including_us_45_days_cruise, '.t-single-worldwide-including-us .t-six-month-cruise'
      element :single_worldwide_including_us_55_days_land, '.t-single-worldwide-including-us .t-six-month-plus-land'
      element :single_worldwide_including_us_55_days_cruise, '.t-single-worldwide-including-us .t-six-month-plus-cruise'

      element :annual_worldwide_including_us_30_days_land, '.t-annual-worldwide-including-us .t-one-month-land'
      element :annual_worldwide_including_us_30_days_cruise, '.t-annual-worldwide-including-us .t-one-month-cruise'
      element :annual_worldwide_including_us_45_days_land, '.t-annual-worldwide-including-us .t-six-month-land'
      element :annual_worldwide_including_us_45_days_cruise, '.t-annual-worldwide-including-us .t-six-month-cruise'
      element :annual_worldwide_including_us_55_days_land, '.t-annual-worldwide-including-us .t-six-month-plus-land'
      element :annual_worldwide_including_us_55_days_cruise, '.t-annual-worldwide-including-us .t-six-month-plus-cruise'

      # Service details section
      element :offers_telephone_quote_yes, '.t-offers-telephone-quote-yes'
      element :offers_telephone_quote_no, '.t-offers-telephone-quote-no'
      element :covid19_medical_repatriation, '.t-covid19-medical-repatriation-yes'
      element :covid19_medical_repatriation, '.t-covid19-medical-repatriation-no'
      element :covid19_medical_repatriation, '.t-covid19-cancellation-cover-yes'
      element :covid19_medical_repatriation, '.t-covid19-cancellation-cover-no'
      element :covers_specialist_equipment_yes, '.t-covers-specialist-equipment-yes'
      element :covers_specialist_equipment_no, '.t-covers-specialist-equipment-no'
      element :covers_specialist_equipment_cost, '.t-covers-specialist-equipment-cost'
      element :medial_screening_company, '.t-medical-screening-company'
      element :how_far_in_advance_cover, '.t-how-far-in-advance-cover'
      element :save_button, '.t-save-button'

      # Medical specialism section
      element :specialised_medical_conditions_yes, '.t-specialised-medical-conditions-yes'
      element :specialised_medical_conditions_no, '.t-specialised-medical-conditions-no'
      element :specialised_medical_conditions_cover, '.t-specialised-medical-conditions-cover'
      element :not_covering_medical_conditions_yes, '.t-not-covering-medical-condition-yes'
      element :not_covering_medical_conditions_no, '.t-not-covering-medical-condition-no'
      element :not_covering_medical_conditions_text, '.t-not-covering-medical-condition textarea'
      element :covers_undergoing_treatment_yes, '.t-cover-undergoing-treatment-yes'
      element :covers_undergoing_treatment_no, '.t-cover-undergoing-treatment-no'
      element :covers_terminal_prognosis, '.t-covers-terminal-prognosis'
    end
  end
end
