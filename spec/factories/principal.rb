FactoryGirl.define do
  sequence(:fca_number, 100000) { |n| n }
  sequence(:email_address) { |n| "principal#{n}@example.com" }

  factory :principal do
    before(:create) { |p| Lookup::Firm.create!(fca_number: p.fca_number) }

    fca_number
    email_address
  end
end
