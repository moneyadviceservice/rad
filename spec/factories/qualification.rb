FactoryGirl.define do
  sequence(:name) { |n| "Qualification #{n}" }

  factory :qualification do
    name
  end
end
