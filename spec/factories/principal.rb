FactoryGirl.define do
  sequence(:fca_number, 100000) { |n| n }
  sequence(:email_address) { |n| "principal#{n}@example.com" }

  factory :principal do
    fca_number
    email_address

    after(:build) { |p| Lookup::Firm.create!(fca_number: p.fca_number) }
  end
end
