FactoryBot.define do
  factory :travel_insurance_firm do
    fca_number
    registered_name
    hidden_at { nil }

    transient do
      with_associated_principle { false }
    end

    transient do
      with_main_office { false }
    end

    transient do
      with_medical_specialism { false }
    end

    transient do
      with_service_detail { false }
    end

    transient do
      with_trip_covers { false }
    end

    transient do
      completed_firm { false }
    end

    trait :hidden do
      with_service_detail { true }
      with_associated_principle { true }
      with_main_office { true }
      with_medical_specialism { true }
      with_trip_covers { true }
      approved_at { Time.utc(2021, 1, 6) }
      hidden_at { Time.utc(2021, 1, 7) }
    end
    factory :travel_insurance_firm_hidden, traits: [:hidden]

    trait :not_approved do
      with_service_detail { true }
      with_associated_principle { true }
      with_main_office { true }
      with_medical_specialism { true }
      with_trip_covers { true }
      approved_at { nil }
    end
    factory :travel_insurance_firm_not_approved, traits: [:not_approved]

    trait :approved do
      with_service_detail { true }
      with_associated_principle { true }
      with_main_office { true }
      with_medical_specialism { true }
      with_trip_covers { true }
      approved_at { Time.utc(2021, 1, 6) }
    end
    factory :travel_insurance_firm_approved, traits: [:approved]

    trait :with_principal do
      with_associated_principle { true }
    end
    factory :travel_insurance_firm_with_principal, traits: [:with_principal]

    factory :travel_trading_name, aliases: [:travel_subsidiary] do
      parent factory: :travel_insurance_firm_with_principal
    end

    after(:build) do |travel_insurance_firm, evaluator|
      next unless evaluator.with_associated_principle || evaluator.completed_firm

      create(:principal, manually_build_firms: true, fca_number: travel_insurance_firm.fca_number)
    end

    after(:build) do |travel_insurance_firm, evaluator|
      next unless evaluator.with_main_office || evaluator.completed_firm

      create(:office, officeable: travel_insurance_firm, opening_time: create(:opening_time))
    end

    after(:build) do |travel_insurance_firm, evaluator|
      next unless evaluator.with_medical_specialism || evaluator.completed_firm

      create(:medical_specialism, travel_insurance_firm: travel_insurance_firm)
    end

    after(:build) do |travel_insurance_firm, evaluator|
      next unless evaluator.with_service_detail || evaluator.completed_firm

      create(:service_detail, travel_insurance_firm: travel_insurance_firm)
    end

    trait :with_trading_names do
      subsidiaries { create_list(:travel_trading_name, 3, fca_number: fca_number) }
    end

    after(:build) do |travel_insurance_firm, evaluator|
      next unless evaluator.with_trip_covers || evaluator.completed_firm

      TripCover::COVERAGE_AREAS.each do |area|
        create(:trip_cover, cover_area: area, trip_type: 'single_trip', travel_insurance_firm: travel_insurance_firm)
        create(:trip_cover, cover_area: area, trip_type: 'annual_multi_trip', travel_insurance_firm: travel_insurance_firm)
      end
    end
  end
end
