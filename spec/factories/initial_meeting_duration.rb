FactoryGirl.define do
  sequence(:duration) { |n| n * 15 }

  factory :initial_meeting_duration do
    duration
  end
end
