FactoryBot.define do
  factory :trip_cover do
    travel_insurance_firm { nil }
    trip_type { 'single_trip' }
    cover_area { 'uk_and_europe' }
    one_month_land_max_age { '62' }
    one_month_cruise_max_age { '62' }
    six_month_land_max_age { '62' }
    six_month_cruise_max_age { '62' }
    six_month_plus_land_max_age { '62' }
    six_month_plus_cruise_max_age { '62' }
  end
end
