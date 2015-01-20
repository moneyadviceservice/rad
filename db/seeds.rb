if Rails.env.development?
  FactoryGirl.create_list(:principal, 3)
  FactoryGirl.create_list(:service_region, rand(3..9))
  FactoryGirl.create_list(:in_person_advice_method, rand(3..5))
  FactoryGirl.create_list(:other_advice_method, rand(1..3))
  FactoryGirl.create_list(:initial_meeting_duration, rand(3..5))
  FactoryGirl.create_list(:initial_advice_fee_structure, rand(3..5))
  FactoryGirl.create_list(:ongoing_advice_fee_structure, rand(3..5))
  FactoryGirl.create_list(:allowed_payment_method, rand(2..3))
end
