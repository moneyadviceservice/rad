RSpec.feature 'The principal dashboard' do
  let(:dashboard_page) { Dashboard::DashboardPage.new }

  scenario 'The principal can see a summary of the firms they are associated with' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_a_firm_with_trading_names
    and_i_am_logged_in
    when_i_am_on_the_principal_dashboard
    then_i_can_see_the_list_of_firms_i_am_associated_with
    then_the_top_level_firm_is_first_and_labelled_main
    and_the_trading_names_are_present_and_labelled_trading_names
  end

  scenario 'The principal can see a summary of the advisers they are associated with' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_a_firm_with_trading_names
    and_i_am_logged_in
    when_i_am_on_the_principal_dashboard
    then_i_can_see_the_list_of_most_recently_edited_advisers
    then_i_can_see_the_total_number_of_advisers
  end

  def given_i_am_a_fully_registered_principal_user
    @principal = FactoryGirl.create(:principal)
    @user = FactoryGirl.create(:user, principal: @principal)
  end

  def and_i_have_a_firm_with_trading_names
    firm_attrs = FactoryGirl.attributes_for(:firm_with_subsidiaries, fca_number: @principal.fca_number)
    @principal.firm.update_attributes(firm_attrs)
  end

  def and_i_am_logged_in
    login_as(@user, scope: :user)
  end

  def when_i_am_on_the_principal_dashboard
    dashboard_page.load
    expect(dashboard_page).to be_displayed
  end

  def then_i_can_see_the_list_of_firms_i_am_associated_with
    expect(dashboard_page).to have_firms(count: @principal.firm.subsidiaries.count + 1)
  end

  def then_the_top_level_firm_is_first_and_labelled_main
    expect(dashboard_page.firms.first).to have_name(text: @principal.firm.registered_name)
    expect(dashboard_page.firms.first).to have_type(text: 'Main')
  end

  def and_the_trading_names_are_present_and_labelled_trading_names
    names = @principal.firm.subsidiaries.map(&:registered_name)

    dashboard_page.trading_names.each do |trading_name|
      expect(names).to include trading_name.name.text
      expect(trading_name.type).to have_text 'Trading name'
    end
  end

  def then_i_can_see_the_list_of_most_recently_edited_advisers
    advisers = Adviser.on_firms_with_fca_number(@principal.firm.fca_number).most_recently_edited

    dashboard_page.advisers.each.with_index do |adviser, idx|
      expect(adviser).to have_name(text: advisers[idx].name)
    end
  end

  def then_i_can_see_the_total_number_of_advisers
    adviser_count = Adviser.on_firms_with_fca_number(@principal.firm.fca_number).size
    expect(dashboard_page.adviser_count).to have_text(adviser_count)
  end
end
