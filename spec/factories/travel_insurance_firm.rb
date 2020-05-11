FactoryBot.define do
  factory :travel_insurance_firm do
    fca_number
    registered_name
    approved_at { Time.zone.now }

    transient do
      create_associated_principle { false }
    end

    after(:build) do |travel_insurance_firm, evaluator|
      create(:principal, manually_build_firms: true, fca_number: travel_insurance_firm.fca_number) if evaluator.create_associated_principle
    end
  end
end
