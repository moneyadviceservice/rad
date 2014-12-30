RSpec.feature 'Importing a Firm\'s Subsidiaries' do
  scenario 'Successfully' do
    given_an_imported_firm
    when_i_import_the_firms_subsidiaries
    then_the_subsidiaries_are_associated_with_the_firm
  end

  scenario 'Attempting to import an invalid Subsidiary' do
    given_an_imported_firm
    when_i_attempt_to_import_invalid_subsidiaries
    then_an_error_is_displayed
    and_no_subsidiaries_are_imported
  end


  def when_i_attempt_to_import_invalid_subsidiaries
    @importer = Import::Importer.new(
      Rails.root.join('spec', 'fixtures', 'invalid_firm_names.ext'),
      Import::Mappers::SubsidiaryMapper.new(Lookup::Subsidiary)
    )
  end

  def then_an_error_is_displayed
    expect { @importer.import }.to raise_error(ActiveRecord::RecordInvalid)
  end

  def and_no_subsidiaries_are_imported
    expect(@firm.subsidiaries).to be_empty
  end

  def given_an_imported_firm
    @firm = Lookup::Firm.create!(fca_number: 100013, registered_name: 'Ben Lovell Ltd')
  end

  def when_i_import_the_firms_subsidiaries
    Import::Importer.new(
      Rails.root.join('spec', 'fixtures', 'firm_names.ext'),
      Import::Mappers::SubsidiaryMapper.new(Lookup::Subsidiary)
    ).import
  end

  def then_the_subsidiaries_are_associated_with_the_firm
    expect(@firm.subsidiaries).to_not be_empty
  end
end
