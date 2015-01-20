FactoryGirl.define do
  factory :firm do
    fca_number
    registered_name 'Financial Advice Ltd'
    email_address { Faker::Internet.email }
    telephone_number { Faker::Base.numerify('##### ### ###') }
    address_line_1 { Faker::Address.street_address }
    address_line_2 { Faker::Address.secondary_address }
    address_town { Faker::Address.city }
    address_county { Faker::Address.state }
    address_postcode 'EC1N 2TD'
  end
end
