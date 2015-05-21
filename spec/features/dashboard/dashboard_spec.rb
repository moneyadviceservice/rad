RSpec.feature 'The principal dashboard' do
  let(:dashboard_page) { DashboardPage.new }

  scenario 'The principal can see a summary of the firms they are associated with' do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in
    when_i_am_on_the_principal_dashboard
    then_i_can_see_the_list_of_firms_i_am_associated_with
  end

  def given_i_am_a_fully_registered_principal_user
    @principal = FactoryGirl.create(:principal)
    @user = FactoryGirl.create(:user, principal: @principal)
    firm_attrs = FactoryGirl.attributes_for(:firm, fca_number: @principal.fca_number)
    @principal.firm.update_attributes(firm_attrs)
  end

  def and_i_am_logged_in
    login_as(@user, scope: :user)
  end

  def when_i_am_on_the_principal_dashboard
    visit dashboard_root_path
  end

  def then_i_can_see_the_list_of_firms_i_am_associated_with
    expect(dashboard_page.firms).to be
  end
end
