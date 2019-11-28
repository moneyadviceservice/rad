FactoryBot.define do
  factory :principal do
    fca_number
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email_address { Faker::Internet.email(first_name) }
    job_title { Faker::Name.title }
    telephone_number { '07111 333 222' }
    confirmed_disclaimer { true }

    after(:build) do |principal|
      if principal.firm.blank?
        principal.firm = Firm.new(
          fca_number: principal.fca_number,
          registered_name:  Faker::Name.first_name
        )
      end
    end
  end
end
