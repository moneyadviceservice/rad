FactoryBot.define do
  factory :travel_insurance_firm do
    fca_number
    registered_name
    approved_at { Time.zone.now }
  end
end
