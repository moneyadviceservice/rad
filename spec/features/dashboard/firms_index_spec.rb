RSpec.feature 'The dashboard firm list page' do
  let(:firms_index_page) { Dashboard::FirmsIndexPage.new }

  scenario 'The principal can see a list of the firms they are associated with' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_a_firm_with_trading_names
    and_i_am_logged_in
    when_i_am_on_the_principal_dashboard_firms_page
    then_i_can_see_the_parent_firm_i_am_associated_with
    then_i_can_see_the_list_of_trading_names_i_am_associated_with
    then_i_can_see_the_list_of_available_trading_names
  end

  def given_i_am_a_fully_registered_principal_user
    @principal = FactoryGirl.create(:principal)
    @user = FactoryGirl.create(:user, principal: @principal)
  end

  def and_i_have_a_firm_with_trading_names
    @lookup_trading_name = FactoryGirl.create(:lookup_subsidiary, fca_number: @principal.fca_number)
    firm_attrs = FactoryGirl.attributes_for(:firm_with_trading_names, fca_number: @principal.fca_number)
    @principal.firm.update_attributes(firm_attrs)
  end

  def and_i_am_logged_in
    login_as(@user, scope: :user)
  end

  def when_i_am_on_the_principal_dashboard_firms_page
    firms_index_page.load
    expect(firms_index_page).to be_displayed
  end

  def expect_firm_table_row(firm_row, firm)
    expect(firm_row).to have_frn(text: firm.fca_number)
    expect(firm_row).to have_name(text: firm.registered_name)
    expect(firm_row).to have_principal_name(text: firm.principal.full_name)
  end

  def then_i_can_see_the_parent_firm_i_am_associated_with
    expect(firms_index_page).to have_parent_firm
    expect_firm_table_row(firms_index_page.parent_firm, @principal.firm)
  end

  def then_i_can_see_the_list_of_trading_names_i_am_associated_with
    trading_names = @principal.firm.trading_names.sorted_by_registered_name
    firms_index_page.trading_names.zip(trading_names).each do |trading_name_section, trading_name|
      expect_firm_table_row(trading_name_section, trading_name)
    end
  end

  def then_i_can_see_the_list_of_available_trading_names
    expect(firms_index_page.available_trading_names.size).to eq 1
    expect(firms_index_page.available_trading_names.first).to have_name(text: @lookup_trading_name.name)
  end
end
