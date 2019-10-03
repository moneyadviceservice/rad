RSpec.feature 'FCA File import' do
  before do
    Cloud::Storage.setup
  end

  after do
    Cloud::Storage.teardown
  end

  let(:file_names) {
    [
      'incoming-20160910a.zip',
      'incoming-20160910b.zip',
      'incoming-20160910c.zip'
    ]
  }

  scenario 'View all files available for import' do
    given_some_import_files_have_been_uploaded
    when_i_am_viewing_the_fca_import_page
    then_i_can_see_the_files_ready_for_import
  end

  private

  def given_some_import_files_have_been_uploaded
    file_names.each do |name|
      Cloud::Storage.upload(name)
    end
  end

  def when_i_am_viewing_the_fca_import_page
    visit admin_lookup_fca_import_index_path
  end

  def then_i_can_see_the_files_ready_for_import
    file_names.each do |name|
      expect(page).to have_content "#{name}"
    end
  end
end
