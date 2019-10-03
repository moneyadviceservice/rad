RSpec.feature "Editing a user (i.e. a Principal's login credentials)" do
  let(:admin_principal_page) { Admin::PrincipalPage.new }
  let(:edit_admin_principal_user_page) { Admin::EditPrincipalUserPage.new }

  scenario "Admin edits a Princpal's login email" do
    given_there_is_firm
    when_i_visit_the_principal_page
    and_i_click_edit_login_credentials
    and_i_change_the_email_address
    and_i_click_save

    then_the_users_email_address_should_have_been_updated
    and_i_am_redirected_to_the_principal_page
  end

  scenario "Admin resets a Princpal's password" do
    given_there_is_firm
    when_i_visit_the_principal_page
    and_i_click_edit_login_credentials
    and_i_enter_a_new_password_and_confirmation
    and_i_click_save

    then_the_users_password_should_have_been_updated
    and_i_am_redirected_to_the_principal_page
  end

  def given_there_is_firm
    @firm = FactoryBot.create(:firm_with_trading_names, :with_principal)
    @principal = @firm.principal
    @principal.update(firm: @firm)
    @user = FactoryBot.create(:user, principal: @principal)
  end

  def when_i_visit_the_principal_page
    admin_principal_page.load(principal_token: @principal.id)
  end

  def and_i_click_edit_login_credentials
    admin_principal_page.edit_login_credentials.click
  end

  def and_i_change_the_email_address
    @new_email_address = Faker::Internet.email
    edit_admin_principal_user_page.email_address.set @new_email_address
  end

  def and_i_enter_a_new_password_and_confirmation
    # Faker can't generate a password that meets our requirements
    @new_password = 'aBcD1234+-_.'.split('').shuffle.join
    edit_admin_principal_user_page.password.set @new_password
    edit_admin_principal_user_page.password_confirmation.set @new_password
  end

  def and_i_click_save
    edit_admin_principal_user_page.save.click
  end

  def then_the_users_email_address_should_have_been_updated
    expect(@user.reload.email).to eq @new_email_address
  end

  def then_the_users_password_should_have_been_updated
    expect(@user.reload).to be_valid_password(@new_password)
  end

  def and_i_am_redirected_to_the_principal_page
    expect(page.current_path).to eq admin_principal_path(@principal)
  end
end
