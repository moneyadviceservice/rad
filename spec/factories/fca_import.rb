FactoryGirl.define do
  factory :not_confirmed_import, class: FcaImport do
    files 'incoming/20160901a.zip, incoming/20160901b.zip, incoming/20160901c.zip'
    confirmed false
    cancelled false
    result ''
  end

  factory :confirmed_import, class: FcaImport do
    files 'incoming/20160901a.zip, incoming/20160901b.zip, incoming/20160901c.zip'
    confirmed true
    cancelled false
    result ''
  end
end
