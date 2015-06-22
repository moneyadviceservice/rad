RSpec.feature 'The principal dashboard' do
  let(:dashboard_page) { Dashboard::DashboardPage.new }

  scenario 'The principal can see a summary of the firms they are associated with' do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in

    when_i_go_to_the_principal_dashboard
    then_i_can_see_the_list_of_recently_edited_firms(count: 1)
    then_the_parent_firm_is_first_and_labelled_main

    given_my_firm_has_trading_names(count: 2)
    when_i_go_to_the_principal_dashboard
    then_the_trading_names_are_present_and_labelled_trading_names

    given_i_modify_a_trading_name_record
    when_i_go_to_the_principal_dashboard
    then_the_modified_trading_name_is_shown_first

    given_my_total_number_of_firms_is(3)
    when_i_go_to_the_principal_dashboard
    then_i_can_see_the_list_of_recently_edited_firms(count: 3)
    then_there_is_no_link_to_see_all_firms

    given_my_total_number_of_firms_is(4)
    when_i_go_to_the_principal_dashboard
    then_i_see_only_the_3_most_recently_updated_firms
    then_there_is_a_link_to_see_all_firms
  end

  scenario 'The principal can see a summary of the advisers they are associated with' do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in

    when_i_go_to_the_principal_dashboard
    then_i_can_see_the_list_of_most_recently_updated_advisers
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
    expect(@principal.main_firm_with_trading_names).to have(1 + count).items
  end

  def given_i_modify_a_trading_name_record
    @modified_trading_name = @principal.firm.trading_names.last
    @modified_trading_name.update!(updated_at: (Time.zone.now + 1.hour))
  end

  def given_my_total_number_of_firms_is(total)
    # main firm + n trading names
    given_my_firm_has_trading_names(count: total - 1)
  end

  def and_i_am_logged_in
    login_as(@user, scope: :user)
  end

  def when_i_go_to_the_principal_dashboard
    dashboard_page.load
    expect(dashboard_page).to be_displayed
  end

  def then_i_can_see_the_list_of_recently_edited_firms(count:)
    expect(dashboard_page).to have_firms
    expect_recently_updated_firms(count: count)
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

  def then_the_modified_trading_name_is_shown_first
    expect(dashboard_page.firms.first.name).to have_text(@modified_trading_name.registered_name)
  end

  def then_i_see_only_the_3_most_recently_updated_firms
    expect_recently_updated_firms(count: 3)
  end

  def then_there_is_no_link_to_see_all_firms
    expect(dashboard_page).not_to have_view_all_firms_link
  end

  def then_there_is_a_link_to_see_all_firms
    expect(dashboard_page).to have_view_all_firms_link
    expect(dashboard_page.view_all_firms_link).to have_text(I18n.t('dashboard.view_all_firms_link'))
  end

  def then_i_can_see_the_list_of_most_recently_updated_advisers
    advisers = Adviser.on_firms_with_fca_number(@principal.firm.fca_number).most_recently_updated

    dashboard_page.advisers.each.with_index do |adviser, idx|
      expect(adviser).to have_name(text: advisers[idx].name)
    end
  end

  private

  def expect_recently_updated_firms(count:)
    expect(dashboard_page).to have(count).firms

    expected_names = @principal
                     .main_firm_with_trading_names
                     .most_recently_updated(limit: count)
                     .map(&:registered_name)
    actual_names = dashboard_page.firms.map { |firm| firm.name.text }
    expect(actual_names).to match_array(expected_names)
  end
end
