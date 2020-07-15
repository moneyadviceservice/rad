FactoryBot.define do
  factory :trip_cover do
    travel_insurance_firm { nil }
    trip_type { "MyString" }
    cover_area { "MyString" }
    one_month_land_max_age { "MyString" }
    one_month_cruise_max_age { "MyString" }
    six_month_land_max_age { "MyString" }
    six_month_cruise_max_age { "MyString" }
    six_month_plus_land_max_age { "MyString" }
    six_month_plus_cruise_max_age { "MyString" }
  end
end
