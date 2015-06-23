RSpec.feature 'The self service navigation' do
  let(:firms_index_page) { SelfService::FirmsIndexPage.new }

  scenario 'The signed-in principal can see navigation links' do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in
    and_i_visit_the_firms_page
    then_i_can_see_the_dashboard_navigation_links
  end

  scenario 'does not show the self service navigation links when not signed in' do
    given_i_am_a_fully_registered_principal_user
    and_i_visit_the_firms_page
    then_i_can_not_see_the_dashboard_navigation_links
  end

  def given_i_am_a_fully_registered_principal_user
    @principal = FactoryGirl.create(:principal)
    @user = FactoryGirl.create(:user, principal: @principal)
  end

  def and_i_am_logged_in
    login_as(@user, scope: :user)
  end

  def and_i_visit_the_firms_page
    firms_index_page.load
  end

  def then_i_can_see_the_dashboard_navigation_links
    expect(firms_index_page.navigation).to have_dashboard_links
  end

  def then_i_can_not_see_the_dashboard_navigation_links
    expect(firms_index_page.navigation).to_not have_dashboard_links
  end
end
