module FcaImportPage
  def admin
    @admin ||= FactoryGirl.create(:user)
    @admin
  end

  def login_as(user)
    visit new_user_session_path
    within('#new_user') do
      fill_in 'user[login]',    with: admin.principal.fca_number
      fill_in 'user[password]', with: admin.password
    end
  end

  def goto_listing_page
    visit admin_fca_imports_listing_path
  end
end
