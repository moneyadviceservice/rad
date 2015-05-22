RSpec.feature 'The principal dashboard' do
  let(:dashboard_page) { DashboardPage.new }

  scenario 'The principal can see a summary of the firms they are associated with' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_a_firm_with_subsidiaries
    and_i_am_logged_in
    when_i_am_on_the_principal_dashboard
    then_i_can_see_the_list_of_firms_i_am_associated_with
  end

  def given_i_am_a_fully_registered_principal_user
    @principal = FactoryGirl.create(:principal)
    @user = FactoryGirl.create(:user, principal: @principal)
  end

  def and_i_have_a_firm_with_subsidiaries
    firm_attrs = FactoryGirl.attributes_for(:firm_with_subsidiaries, fca_number: @principal.fca_number)
    @principal.firm.update_attributes(firm_attrs)
  end

  def and_i_am_logged_in
    login_as(@user, scope: :user)
  end

  def when_i_am_on_the_principal_dashboard
    visit dashboard_root_path
  end

  def then_i_can_see_the_list_of_firms_i_am_associated_with
    expect(dashboard_page.firms).to have_text @principal.firm.registered_name
    @principal.firm.subsidiaries.each do |subsidiary|
      expect(dashboard_page.firms).to have_text subsidiary.registered_name
    end
  end
end
