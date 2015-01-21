FactoryGirl.define do
  factory :firm do
    email_address { Faker::Internet.email }
    telephone_number { Faker::Base.numerify('##### ### ###') }
    address_line_1 { Faker::Address.street_address }
    address_line_2 { Faker::Address.secondary_address }
    address_town { Faker::Address.city }
    address_county { Faker::Address.state }
    address_postcode 'EC1N 2TD'
    service_regions { create_list(:service_region, rand(1..3)) }
    in_person_advice_methods { create_list(:in_person_advice_method, rand(1..3)) }
    other_advice_methods { create_list(:other_advice_method, rand(1..3)) }
    free_initial_meeting { [true, false].sample }
    initial_meeting_duration { create(:initial_meeting_duration) }
    initial_advice_fee_structures { create_list(:initial_advice_fee_structure, rand(1..3)) }
    ongoing_advice_fee_structures { create_list(:ongoing_advice_fee_structure, rand(1..3)) }
    allowed_payment_methods { create_list(:allowed_payment_method, rand(1..3)) }
    investment_size { create(:investment_size) }
  end
end
