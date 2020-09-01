FactoryBot.define do
  factory :medical_specialism do
    travel_insurance_firm { nil }
    specialised_medical_conditions_covers_all { false }
    specialised_medical_conditions_cover { 'cancer' }
    will_not_cover_some_medical_conditions { true }
    likely_not_cover_medical_condition { 'heart_condition' }
    will_cover_undergoing_treatment { false }
    cover_undergoing_treatment { 'Reason why not' }
    terminal_prognosis_cover { true }
  end
end
