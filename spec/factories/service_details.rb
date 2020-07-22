FactoryBot.define do
  factory :service_detail do
    travel_insurance_firm { nil }
    offers_telephone_quote { true }
    covid19_medical_repatriation { true }
    covid19_cancellation_cover { true }
    cover_for_specialist_equipment { 'equipment_name' }
    medical_screening_company { 'verisik' }
    how_far_in_advance_trip_cover { 'one_month_plus' }
  end
end
