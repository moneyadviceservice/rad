FactoryBot.define do
  factory :medical_specialism do
    travel_insurance_firm { nil }
    specialised_medical_conditions_cover { 'cancer' }
    likely_not_cover_medical_condition { 'heart_condition' }
    cover_undergoing_treatment { true }
    terminal_prognosis_cover { true }
  end
end
