RSpec.feature 'Importing Firm Lookup Data' do
  scenario 'Importing a firm successfully' do
    csv      = Rails.root.join('spec', 'fixtures', 'firms.ext')
    importer = Import::Importer.new(
      csv,
      Import::Mappers::FirmMapper.new(Lookup::Firm)
    )

    expect { importer.import }.to change { Lookup::Firm.count }.by(1)
  end
end
