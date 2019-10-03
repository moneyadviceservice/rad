RSpec.feature "Editing a principal's details (as shown in the directory)" do
  let(:admin_principal_page) { Admin::PrincipalPage.new }
  let(:edit_admin_principal_page) { Admin::EditPrincipalPage.new }

  scenario "Admin edits a Princpal's directory email" do
    given_there_is_firm
    when_i_visit_the_principal_page
    and_i_click_edit_directory_information
    and_i_change_the_email_address
    and_i_click_save

    then_the_principals_email_address_should_have_been_updated
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

  def and_i_click_edit_directory_information
    admin_principal_page.edit_directory_information.click
  end

  def and_i_change_the_email_address
    @new_email_address = Faker::Internet.email
    edit_admin_principal_page.email_address.set @new_email_address
  end

  def and_i_click_save
    edit_admin_principal_page.save.click
  end

  def then_the_principals_email_address_should_have_been_updated
    expect(@principal.reload.email_address).to eq @new_email_address
  end

  def and_i_am_redirected_to_the_principal_page
    expect(page.current_path).to eq admin_principal_path(@principal)
  end
end
