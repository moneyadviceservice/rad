FactoryBot.define do
  factory :opening_time do
    office
    weekday_opening_time { '2020-06-17 09:00:00' }
    weekday_closing_time { '2020-06-17 17:30:00' }
    saturday_opening_time { '2020-06-17 09:00:00' }
    saturday_closing_time { '2020-06-17 17:30:00' }
    sunday_opening_time { '2020-06-17 09:00:00' }
    sunday_closing_time { '2020-06-17 17:30:00' }
  end
end
