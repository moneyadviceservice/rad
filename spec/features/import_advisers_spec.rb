RSpec.feature 'Importing Advisers' do
  scenario 'Successfully' do
    given_a_valid_import_file
    when_i_import_the_advisers
    then_the_advisers_are_successfully_imported
  end

  scenario 'Attempting to import an invalid Adviser' do
    given_an_invalid_import_file
    when_i_attempt_to_import_invalid_advisers
    then_an_error_is_displayed
    and_no_advisers_are_imported
  end


  def given_an_invalid_import_file
    @importer = Import::Importer.new(
      Rails.root.join('spec', 'fixtures', 'invalid_advisers.ext'),
      Import::Mappers::AdviserMapper.new(Lookup::Adviser)
    )
  end

  def when_i_attempt_to_import_invalid_advisers
    begin
      @importer.import
    rescue ActiveRecord::RecordInvalid => e
      @error = e
    end
  end

  def then_an_error_is_displayed
    expect(@error).to be
  end

  def and_no_advisers_are_imported
    expect(Lookup::Adviser.count).to eql(0)
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
