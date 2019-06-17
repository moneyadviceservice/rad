RSpec.feature 'Verify a firm\'s fca number' do
  let(:admin_firm_page) { Admin::FirmPage.new }
  let(:admin_firm_index_page) { Admin::FirmsIndexPage.new }

  scenario 'Admin verifies the fca reference number' do
    given_there_is_firm
    when_i_visit_the_firm_page
    when_i_see_the_fca_not_verified_message
    then_i_dont_see_the_approve_button
    when_i_click_verify_fca_reference    
    then_the_firm_should_be_fca_verified
    then_i_see_the_approve_button
  end

  def given_there_is_firm
    @principal = FactoryGirl.create(:principal)
    @firm = @principal.firm
    @user = FactoryGirl.create(:user, principal: @principal)
  end

  def when_i_visit_the_firm_page
    admin_firm_page.load(firm_id: @firm.id)
  end

  def when_i_see_the_fca_not_verified_message
    expect(admin_firm_page).to have_fca_not_verified_warning
  end

  def when_i_click_verify_fca_reference
    admin_firm_page.verify_fca_reference_button.click
  end

  def then_the_firm_should_be_fca_verified
    expect(admin_firm_page).to_not have_fca_not_verified_warning
    expect(admin_firm_page).to_not have_verify_fca_reference_button
  end

  def then_i_dont_see_the_approve_button
    expect(admin_firm_page).not_to have_approve_button
  end

  def then_i_see_the_approve_button
    expect(admin_firm_page).to have_approve_button
  end
end
