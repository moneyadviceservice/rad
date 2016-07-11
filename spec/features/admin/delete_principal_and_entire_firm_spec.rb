RSpec.feature 'Deleting principal and all related firm, adviser, office and trading name data' do
  let(:admin_principal_page) { Admin::EditPrincipalPage.new }

  scenario 'Admin deletes a principal and all related data' do
    given_there_is_firm
    when_i_visit_the_principal_page
    and_i_click_delete
    then_the_principal_and_all_related_data_is_removed
    and_i_am_redirected_to_the_principal_list_page
  end

  def given_there_is_firm
    @firm = FactoryGirl.create(:firm_with_trading_names, :with_principal)
    @principal = @firm.principal
    @principal.update(firm: @firm)
    @user = FactoryGirl.create(:user, principal: @principal)

    expect(User.find_by(principal: @principal)).to eq(@user)
    expect(@principal).not_to be_nil
    expect(@firm.offices.count).to be(1)
    expect(@firm.advisers.count).to be(1)
    expect(@firm.trading_names.count).to be(3)

    @office = @firm.offices[0]
    @adviser = @firm.advisers[0]
    @trading_name = @firm.trading_names[0]
  end

  def when_i_visit_the_principal_page
    admin_principal_page.load(principal_token: @principal.id)
    expect(admin_principal_page).to be_displayed
  end

  def and_i_click_delete
    admin_principal_page.delete.click
  end

  def then_the_principal_and_all_related_data_is_removed
    expect(Principal.exists?(@principal.id)).to be(false)
    expect(Firm.exists?(@firm.id)).to be(false)
    expect(User.exists?(@user.id)).to be(false)
    expect(Office.exists?(@office.id)).to be(false)
    expect(Adviser.exists?(@adviser.id)).to be(false)
    expect(Firm.exists?(@trading_name.id)).to be(false)
  end

  def and_i_am_redirected_to_the_principal_list_page
    expect(page.current_path).to eq admin_principals_path
    expect(find('.t-flash-message')).to have_text('Successfully deleted')
  end
end
