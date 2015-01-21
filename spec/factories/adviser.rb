FactoryGirl.define do
  sequence(:reference_number, 1000) { |n| "ABCD#{n}" }

  factory :adviser do
    reference_number
    name 'Ben Lovell'
    firm
  end
end
