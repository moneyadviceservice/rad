RSpec.feature 'Importing a Firm\'s Subsidiaries' do
  scenario 'Successfully' do
    given_an_imported_firm
    when_i_import_the_firms_subsidiaries
    then_the_subsidiaries_are_associated_with_the_firm
  end


  def given_an_imported_firm
    Lookup::Firm.create!(fca_number: 123456, registered_name: 'Ben Lovell Ltd')
  end

  def when_i_import_the_firms_subsidiaries
    Import::Importer.new(
      Rails.root.join('spec', 'fixtures', 'firm_names.ext'),
      Import::Mappers::SubsidiaryMapper.new(Lookup::Subsidiary)
    ).import
  end

  def then_the_subsidiaries_are_associated_with_the_firm
    skip
  end
end
