if Rails.env.development?
  FactoryGirl.create_list(:principal, 3)
  FactoryGirl.create_list(:service_region, rand(3..9))
  FactoryGirl.create_list(:in_person_advice_method, rand(3..5))
end
