FactoryBot.define do
  sequence(:registered_name) { |n| "Financial Advice #{n} Ltd." }

  factory :not_onboarded_firm, class: Firm, aliases: [:invalid_firm] do
    fca_number
    registered_name
  end

  factory :firm do
    fca_number
    registered_name

    factory :trading_name, aliases: [:subsidiary] do
      parent factory: :firm
    end
  end
end
