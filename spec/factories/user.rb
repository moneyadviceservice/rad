FactoryBot.define do
  factory :user do
    sequence(:email) { Faker::Internet.email }
    password { 'Password1!' }
    password_confirmation { 'Password1!' }

    principal
  end
end
