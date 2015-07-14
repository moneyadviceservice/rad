RSpec.feature 'The self service principal edit page' do
  let(:principal_edit_page) { SelfService::PrincipalEditPage.new }
  let(:principal_changes) { FactoryGirl.build(:principal) }

  scenario 'The principal can view their principal details' do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in
    and_i_am_on_my_principal_edit_page
    then_i_see_my_principal_details
  end

  scenario 'The principal can edit their principal details' do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in
    and_i_am_on_my_principal_edit_page
    and_i_change_my_principal_details
    and_i_submit_the_form
    then_my_principal_details_are_changed
  end

  scenario 'The principal cannot update their principal with invalid details' do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in
    and_i_am_on_my_principal_edit_page
    and_i_change_my_principal_details_to_invalid_details
    and_i_submit_the_form
    then_my_principal_details_are_not_changed
    and_i_see_validation_messages
  end

  def given_i_am_a_fully_registered_principal_user
    @principal = FactoryGirl.create(:principal)
    @user = FactoryGirl.create(:user, principal: @principal)
  end

  def and_i_am_logged_in
    login_as(@user, scope: :user)
  end

  def and_i_am_on_my_principal_edit_page
    principal_edit_page.load(principal_id: @user.principal.id)
  end

  def then_i_see_my_principal_details
    expect(principal_edit_page.first_name.value).to eq @principal.first_name
    expect(principal_edit_page.last_name.value).to eq @principal.last_name
    expect(principal_edit_page.job_title.value).to eq @principal.job_title
    expect(principal_edit_page.email_address.value).to eq @principal.email_address
    expect(principal_edit_page.telephone_number.value).to eq @principal.telephone_number
  end

  def and_i_change_my_principal_details
    principal_edit_page.first_name.set principal_changes.first_name
    principal_edit_page.last_name.set principal_changes.last_name
    principal_edit_page.job_title.set principal_changes.job_title
    principal_edit_page.email_address.set principal_changes.email_address
    principal_edit_page.telephone_number.set principal_changes.telephone_number
  end

  def and_i_change_my_principal_details_to_invalid_details
    principal_edit_page.email_address.set 'not an email'
  end

  def and_i_submit_the_form
    principal_edit_page.save_button.click
  end

  def then_my_principal_details_are_changed
    @principal.reload
    expect(@principal.first_name).to eq principal_changes.first_name
    expect(@principal.last_name).to eq principal_changes.last_name
    expect(@principal.job_title).to eq principal_changes.job_title
    expect(@principal.email_address).to eq principal_changes.email_address
    expect(@principal.telephone_number).to eq principal_changes.telephone_number
  end

  def then_my_principal_details_are_not_changed
    @principal.reload
    expect(@principal.email_address).to_not eq 'not an email'
  end

  def and_i_see_validation_messages
    expect(principal_edit_page).to have_validation_summary
  end
end
