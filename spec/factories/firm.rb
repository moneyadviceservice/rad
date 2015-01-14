FactoryGirl.define do
  factory :firm do
    fca_number
    registered_name 'Financial Advice Ltd'
    email_address { Faker::Internet.email }
    telephone_number { Faker::Base.numerify('##### ### ###') }
  end
end
