FactoryBot.define do
  factory :trip_cover do
    travel_insurance_firm { nil }
    trip_type { 'single_trip' }
    cover_area { 'uk_and_europe' }
    land_30_days_max_age { '69' }
    cruise_30_days_max_age { '69' }
    land_45_days_max_age { '69' }
    cruise_45_days_max_age { '69' }
    land_55_days_max_age { '69' }
    cruise_55_days_max_age { '69' }
  end
end
