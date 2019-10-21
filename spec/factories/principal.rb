FactoryBot.define do
  sequence(:fca_number, 100_000) { |n| n }

  factory :principal do
    fca_number
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email_address { Faker::Internet.email(first_name) }
    job_title { Faker::Name.title }
    telephone_number { '07111 333 222' }
    confirmed_disclaimer { true }

    # TODO: this is problematic if you manually construct your own firm in a
    # spec using FactoryBot and associate it with the principal. You end up
    # with two firms in the database, which is easy to miss and can lead to
    # unexpected bugs. Revisit this and find a better way to associate an
    # invalid Firm (which is a legitimate state for the system to be in, ie - a
    # newly registered principal is expected to complete certain details
    # post-signup).
    after(:build) do |principal|
      Firm.new(
        fca_number: principal.fca_number,
        registered_name:  Faker::Name.first_name
      ).tap do |f|
        f.save!(validate: false)
      end
    end
  end
end
