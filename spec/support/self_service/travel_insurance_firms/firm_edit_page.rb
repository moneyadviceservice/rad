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
      element :single_europe_45_days_land, '.t-single-europe .t-three-month-land'
      element :single_europe_45_days_cruise, '.t-single-europe .t-three-month-cruise'
      element :single_europe_50_days_land, '.t-single-europe .t-three-month-plus-land'
      element :single_europe_50_days_cruise, '.t-single-europe .t-three-month-plus-cruise'
      element :single_europe_55_days_land, '.t-single-europe .t-six-month-plus-land'
      element :single_europe_55_days_cruise, '.t-single-europe .t-six-month-plus-cruise'

      element :annual_europe_30_days_land, '.t-annual-europe .t-one-month-land'
      element :annual_europe_30_days_cruise, '.t-annual-europe .t-one-month-cruise'
      element :annual_europe_45_days_land, '.t-annual-europe .t-three-month-land'
      element :annual_europe_45_days_cruise, '.t-annual-europe .t-three-month-cruise'
      element :annual_europe_55_days_land, '.t-annual-europe .t-six-month-plus-land'
      element :annual_europe_55_days_cruise, '.t-annual-europe .t-six-month-plus-cruise'

      # Worldwide excluding US
      element :single_worldwide_excluding_us_30_days_land, '.t-single-worldwide-excluding-us .t-one-month-land'
      element :single_worldwide_excluding_us_30_days_cruise, '.t-single-worldwide-excluding-us .t-one-month-cruise'
      element :single_worldwide_excluding_us_45_days_land, '.t-single-worldwide-excluding-us .t-three-month-land'
      element :single_worldwide_excluding_us_45_days_cruise, '.t-single-worldwide-excluding-us .t-three-month-cruise'
      element :single_worldwide_excluding_us_50_days_land, '.t-single-worldwide-excluding-us .t-three-month-plus-land'
      element :single_worldwide_excluding_us_50_days_cruise, '.t-single-worldwide-excluding-us .t-three-month-plus-cruise'
      element :single_worldwide_excluding_us_55_days_land, '.t-single-worldwide-excluding-us .t-six-month-plus-land'
      element :single_worldwide_excluding_us_55_days_cruise, '.t-single-worldwide-excluding-us .t-six-month-plus-cruise'

      element :annual_worldwide_excluding_us_30_days_land, '.t-annual-worldwide-excluding-us .t-one-month-land'
      element :annual_worldwide_excluding_us_30_days_cruise, '.t-annual-worldwide-excluding-us .t-one-month-cruise'
      element :annual_worldwide_excluding_us_45_days_land, '.t-annual-worldwide-excluding-us .t-three-month-land'
      element :annual_worldwide_excluding_us_45_days_cruise, '.t-annual-worldwide-excluding-us .t-three-month-cruise'
      element :annual_worldwide_excluding_us_55_days_land, '.t-annual-worldwide-excluding-us .t-six-month-plus-land'
      element :annual_worldwide_excluding_us_55_days_cruise, '.t-annual-worldwide-excluding-us .t-six-month-plus-cruise'

      # Worldwide including US
      element :single_worldwide_including_us_30_days_land, '.t-single-worldwide-including-us .t-one-month-land'
      element :single_worldwide_including_us_30_days_cruise, '.t-single-worldwide-including-us .t-one-month-cruise'
      element :single_worldwide_including_us_45_days_land, '.t-single-worldwide-including-us .t-three-month-land'
      element :single_worldwide_including_us_45_days_cruise, '.t-single-worldwide-including-us .t-three-month-cruise'
      element :single_worldwide_including_us_50_days_land, '.t-single-worldwide-including-us .t-three-month-plus-land'
      element :single_worldwide_including_us_50_days_cruise, '.t-single-worldwide-including-us .t-three-month-plus-cruise'
      element :single_worldwide_including_us_55_days_land, '.t-single-worldwide-including-us .t-six-month-plus-land'
      element :single_worldwide_including_us_55_days_cruise, '.t-single-worldwide-including-us .t-six-month-plus-cruise'

      element :annual_worldwide_including_us_30_days_land, '.t-annual-worldwide-including-us .t-one-month-land'
      element :annual_worldwide_including_us_30_days_cruise, '.t-annual-worldwide-including-us .t-one-month-cruise'
      element :annual_worldwide_including_us_45_days_land, '.t-annual-worldwide-including-us .t-three-month-land'
      element :annual_worldwide_including_us_45_days_cruise, '.t-annual-worldwide-including-us .t-three-month-cruise'
      element :annual_worldwide_including_us_55_days_land, '.t-annual-worldwide-including-us .t-six-month-plus-land'
      element :annual_worldwide_including_us_55_days_cruise, '.t-annual-worldwide-including-us .t-six-month-plus-cruise'

      # Service details section
      element :offers_telephone_quote_yes, '.t-offers-telephone-quote-yes'
      element :offers_telephone_quote_no, '.t-offers-telephone-quote-no'
      element :covers_specialist_equipment_yes, '.t-covers-specialist-equipment-yes'
      element :covers_specialist_equipment_no, '.t-covers-specialist-equipment-no'
      element :covers_specialist_equipment_cost, '.t-covers-specialist-equipment-cost input'
      element :covid19_medical_repatriation_yes, '.t-covid19-medical-repatriation-yes'
      element :covid19_medical_repatriation_no, '.t-covid19-medical-repatriation-no'
      element :covid19_cancellation_cover_yes, '.t-covid19-cancellation-cover-yes'
      element :covid19_cancellation_cover_no, '.t-covid19-cancellation-cover-no'
      element :medial_screening_company, '.t-medical-screening-company'
      element :how_far_in_advance_cover, '.t-how-far-in-advance-cover select'
      element :save_button, '.t-save-button'

      # Medical specialism section
      element :specialised_medical_conditions_covers_all_yes, '.t-specialised-medical-conditions-covers-all-yes'
      element :specialised_medical_conditions_covers_all_no, '.t-specialised-medical-conditions-covers-all-no'
      element :specialised_medical_conditions_cover, '.t-specialised-medical-conditions-cover select'

      element :not_covering_medical_conditions_yes, '.t-not-covering-medical-condition-yes'
      element :not_covering_medical_conditions_no, '.t-not-covering-medical-condition-no'
      element :not_covering_medical_conditions_text, '.t-not-covering-medical-condition-text textarea'

      element :covers_undergoing_treatment_yes, '.t-cover-undergoing-treatment-yes'
      element :covers_undergoing_treatment_no, '.t-cover-undergoing-treatment-no'
      element :covers_undergoing_treatment_text, '.t-cover-undergoing-treatment-text textarea'
      element :covers_terminal_prognosis_yes, '.t-covers-terminal-prognosis-yes'
      element :covers_terminal_prognosis_no, '.t-covers-terminal-prognosis-no'
    end
  end
end
