FactoryBot.define do
  factory :opening_time do
    office
    weekday_opening_time { '2020-06-17 17:12:38' }
    weekday_closing_time { '2020-06-17 17:15:38' }
    saturday_opening_time { '2020-06-17 17:12:38' }
    saturday_closing_time { '2020-06-17 17:15:38' }
    sunday_opening_time { '2020-06-17 17:12:38' }
    sunday_closing_time { '2020-06-17 17:15:38' }
  end
end
