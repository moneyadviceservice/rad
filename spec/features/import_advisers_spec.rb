RSpec.feature 'Importing Advisers' do
  scenario 'Successfully' do
    given_a_valid_import_file
    when_i_import_the_advisers
    then_the_advisers_are_successfully_imported
  end


  def given_a_valid_import_file
    @importer = Import::Importer.new(
      Rails.root.join('spec', 'fixtures', 'advisers.ext'),
      Import::Mappers::AdviserMapper.new(Lookup::Adviser)
    )
  end

  def when_i_import_the_advisers
    @importer.import
  end

  def then_the_advisers_are_successfully_imported
    expect(Lookup::Adviser.count).to eql(2)
  end
end
