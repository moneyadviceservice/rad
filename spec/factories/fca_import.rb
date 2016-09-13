FactoryGirl.define do
  factory :not_confirmed_import, class: FcaImport do
    confirmed false
    cancelled false
    result ''
  end

  factory :confirmed_import, class: FcaImport do
    confirmed true
    cancelled false
    result ''
  end
end
