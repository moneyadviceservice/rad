RSpec.feature 'The principal dashboard' do
  let(:dashboard_page) { Dashboard::DashboardPage.new }

  scenario 'The principal can see a summary of the firms they are associated with' do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in

    when_i_am_on_the_principal_dashboard
    then_i_can_see_the_list_of_recently_edited_firms(count: 1)
    then_the_parent_firm_is_first_and_labelled_main

    given_my_firm_has_trading_names(count: 2)
    when_i_am_on_the_principal_dashboard
    then_the_trading_names_are_present_and_labelled_trading_names
  end

  scenario 'The principal can see a summary of the advisers they are associated with' do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in

    when_i_am_on_the_principal_dashboard
    then_i_can_see_the_list_of_most_recently_edited_advisers
  end

  def given_i_am_a_fully_registered_principal_user
    @principal = FactoryGirl.create(:principal)
    firm_attrs = FactoryGirl.attributes_for(:firm,
                                            fca_number: @principal.fca_number,
                                            registered_name: @principal.lookup_firm.registered_name)
    @principal.firm.update_attributes(firm_attrs)
    @user = FactoryGirl.create(:user, principal: @principal)
  end

  def given_my_firm_has_trading_names(count:)
    @principal.firm.trading_names = create_list(:trading_name,
                                                count,
                                                fca_number: @principal.fca_number)
    @principal.firm.save!
    expect(Firm.where(fca_number: @principal.fca_number).count).to eq(1 + count)
  end

  def and_i_am_logged_in
    login_as(@user, scope: :user)
  end

  def when_i_am_on_the_principal_dashboard
    dashboard_page.load
    expect(dashboard_page).to be_displayed
  end

  def then_i_can_see_the_list_of_recently_edited_firms(count:)
    expect(dashboard_page).to have_firms(count: count)
  end

  def then_the_parent_firm_is_first_and_labelled_main
    expect(dashboard_page.firms.first).to have_name(text: @principal.firm.registered_name)
    expect(dashboard_page.firms.first).to have_type(text: 'Main')
  end

  def then_the_trading_names_are_present_and_labelled_trading_names
    expect(dashboard_page).to have_trading_names(count: @principal.firm.trading_names.count)
    expect(dashboard_page.trading_names).to rspec_all(have_type text: 'Trading name')

    expected_names = @principal.firm.trading_names.map(&:registered_name)
    actual_names = dashboard_page.trading_names.map { |trading_name| trading_name.name.text }
    expect(actual_names).to match_array(expected_names)
  end

  def then_i_can_see_the_list_of_most_recently_edited_advisers
    advisers = Adviser.on_firms_with_fca_number(@principal.firm.fca_number).most_recently_edited

    dashboard_page.advisers.each.with_index do |adviser, idx|
      expect(adviser).to have_name(text: advisers[idx].name)
    end
  end
end
