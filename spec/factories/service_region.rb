FactoryGirl.define do
  factory :service_region do
    name { Faker::Address.city }
  end
end
