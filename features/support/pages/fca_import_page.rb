module FcaImportPage
  def admin
    uri_template = Addressable::Template.new 'http://localhost:9200/rad_test/firms/{id}'
    stub_request(:delete, uri_template)
      .to_return(status: 200, body: '', headers: {})

    @admin ||= FactoryGirl.create(:user)
    @admin
  end

  def login_as(user)
    visit new_user_session_path
    within('#new_user') do
      fill_in 'user[login]',    with: user.principal.fca_number
      fill_in 'user[password]', with: user.password
    end
  end

  def goto_listing_page
    visit admin_lookup_fca_import_index_path
  end

  def upload(filename)
    Cloud::Storage.upload(filename)
  end
end
