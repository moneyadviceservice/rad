RSpec.feature 'The self service navigation' do
  let(:dashboard_page) { SelfService::DashboardPage.new }

  scenario 'The signed-in principal can see dashboard navigation links' do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in
    and_i_visit_the_dashboard
    then_i_can_see_the_dashboard_navigation_links
  end

  scenario 'does not show the self service navigation links when not signed in' do
    given_i_am_a_fully_registered_principal_user
    and_i_visit_the_dashboard
    then_i_can_not_see_the_dashboard_navigation_links
  end

  def given_i_am_a_fully_registered_principal_user
    @principal = FactoryGirl.create(:principal)
    @user = FactoryGirl.create(:user, principal: @principal)
  end

  def and_i_am_logged_in
    login_as(@user, scope: :user)
  end

  def and_i_visit_the_dashboard
    dashboard_page.load
  end

  def then_i_can_see_the_dashboard_navigation_links
    expect(dashboard_page.navigation).to have_dashboard_links
  end

  def then_i_can_not_see_the_dashboard_navigation_links
    expect(dashboard_page.navigation).to_not have_dashboard_links
  end
end
