FactoryGirl.define do
  factory :firm do
    email_address { Faker::Internet.email }
    telephone_number { Faker::Base.numerify('##### ### ###') }
  end
end
