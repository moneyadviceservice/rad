FactoryBot.define do
  factory :service_detail do
    travel_insurance_firm { nil }
    offers_telephone_quote { true }
    cover_for_specialist_equipment { 1 }
    medical_screening_company { "verisik" }
    how_far_in_advance_trip_cover { "one_month_plus" }
  end
end
