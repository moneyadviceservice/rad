FactoryGirl.define do
  factory :import, class: FcaImport do
    files 'incoming/20160831a.zip|incoming/20160831b.zip|incoming/20160831c.zip'
    status 'processing'
    result ''
  end

  factory :not_confirmed_import, class: FcaImport do
    files 'incoming/20160901a.zip|incoming/20160901b.zip|incoming/20160901c.zip'
    status 'processed'
    result ''
  end

  factory :confirmed_import, class: FcaImport do
    files 'incoming/20160902a.zip|incoming/20160902b.zip|incoming/20160901c.zip'
    status 'confirmed'
    result ''
  end
end
