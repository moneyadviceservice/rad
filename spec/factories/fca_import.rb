FactoryGirl.define do
  factory :import, class: FcaImport do
    files { %w(a b c).map { |e| "incoming/#{FFaker::String.from_regexp(/\d{8}/)}#{e}.zip" }.join('|') }
    status 'processing'
    result ''
  end

  factory :not_confirmed_import, class: FcaImport do
    files { %w(a b c).map { |e| "incoming/#{FFaker::String.from_regexp(/\d{8}/)}#{e}.zip" }.join('|') }
    status 'processed'
    result ''
  end

  factory :confirmed_import, class: FcaImport do
    files { %w(a b c).map { |e| "incoming/#{FFaker::String.from_regexp(/\d{8}/)}#{e}.zip" }.join('|') }
    status 'confirmed'
    result ''
  end
end
