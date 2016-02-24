RSpec.feature 'The self service firm list page' do
  let(:firms_index_page) { SelfService::FirmsIndexPage.new }

  scenario 'When there are both available and added trading names' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_a_firm_with_both_available_and_added_trading_names
    and_i_am_logged_in
    when_i_am_on_the_principals_firms_index_page
    then_i_can_see_the_parent_firm_i_am_associated_with
    and_i_can_see_the_list_of_trading_names_i_am_associated_with
    and_i_can_see_the_list_of_available_trading_names
    and_the_page_title_indicates_a_plural
    and_the_parent_firm_section_heading_is_visible
  end

  scenario 'When there are no added or available trading names' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_a_firm_with_no_available_or_added_trading_names
    and_i_am_logged_in
    when_i_am_on_the_principals_firms_index_page
    then_i_can_see_the_parent_firm_i_am_associated_with
    and_the_trading_names_block_is_not_shown
    and_the_available_trading_names_block_is_not_shown
    and_the_page_title_indicates_a_singular
    and_the_parent_firm_section_heading_is_not_visible
  end

  scenario 'When there are available trading names but none have been added' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_a_firm_with_available_trading_names_but_none_added
    and_i_am_logged_in
    when_i_am_on_the_principals_firms_index_page
    then_i_can_see_the_parent_firm_i_am_associated_with
    and_the_trading_names_section_is_showing_a_prompt_to_add_a_trading_name
    and_i_can_see_the_list_of_available_trading_names
    and_the_page_title_indicates_a_plural
    and_the_parent_firm_section_heading_is_visible
  end

  scenario 'The principal can remove trading names' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_a_firm_with_both_available_and_added_trading_names
    and_i_am_logged_in
    and_i_am_on_the_principals_firms_index_page
    and_i_can_see_the_first_trading_name
    when_i_remove_the_first_trading_name
    then_i_am_on_the_principals_firms_index_page
    and_i_cannot_see_the_deleted_trading_name
    and_i_can_see_a_success_message
  end

  scenario 'when the principal is not onboarded' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_no_publishable_firms
    when_i_am_logged_in
    and_i_am_on_the_principals_firms_index_page
    then_i_can_see_the_onboading_message
  end

  scenario 'when the principal is onboarded' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_publishable_firms
    when_i_am_logged_in
    and_i_am_on_the_principals_firms_index_page
    then_i_can_not_see_the_onboading_message
  end

  scenario 'when the parent firm is not published' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_an_unpublished_firm
    when_i_am_logged_in
    and_i_am_on_the_principals_firms_index_page
    then_i_can_see_the_parent_firm_i_am_associated_with
    and_i_should_see_the_overall_status_for_the_parent_firm
    and_the_parent_firm_overall_status_is_unpublished
  end

  scenario 'when the parent firm is published' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_a_published_firm
    when_i_am_logged_in
    and_i_am_on_the_principals_firms_index_page
    then_i_can_see_the_parent_firm_i_am_associated_with
    and_i_should_see_the_overall_status_for_the_parent_firm
    and_the_parent_firm_overall_status_is_published
  end

  scenario 'The principal can see the status of unpublishable trading names' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_a_firm_with_both_available_and_added_trading_names
    and_one_of_those_trading_names_is_unpublishable
    when_i_am_logged_in
    and_i_am_on_the_principals_firms_index_page
    then_i_can_see_the_status_of_the_trading_name
    and_the_trading_name_overall_status_is_unpublished
  end

  scenario 'The principal can see the status of publishable trading names' do
    given_i_am_a_fully_registered_principal_user
    and_i_have_a_firm_with_both_available_and_added_trading_names
    and_one_of_those_trading_names_is_publishable
    when_i_am_logged_in
    and_i_am_on_the_principals_firms_index_page
    then_i_can_see_the_status_of_the_trading_name
    and_the_trading_name_overall_status_is_published
  end

  def given_i_am_a_fully_registered_principal_user
    @principal = FactoryGirl.create(:principal)
    @user = FactoryGirl.create(:user, principal: @principal)
    firm_attrs = FactoryGirl.attributes_for(:firm,
                                            fca_number: @principal.fca_number,
                                            registered_name: @principal.lookup_firm.registered_name)
    @principal.firm.update_attributes(firm_attrs)
  end

  def and_i_have_a_firm_with_both_available_and_added_trading_names
    @lookup_trading_name = FactoryGirl.create(:lookup_subsidiary, fca_number: @principal.fca_number)
    @principal.firm.trading_names = create_list(:trading_name,
                                                3,
                                                fca_number: @principal.fca_number)
    expect(@principal.firm.trading_names).to have(3).items
    expect(@principal.lookup_firm.subsidiaries).to have(1).item
  end

  def and_i_have_a_firm_with_no_available_or_added_trading_names
    expect(@principal.firm.trading_names).to be_empty
    expect(@principal.lookup_firm.subsidiaries).to be_empty
  end

  def and_i_have_a_firm_with_available_trading_names_but_none_added
    @lookup_trading_name = FactoryGirl.create(:lookup_subsidiary, fca_number: @principal.fca_number)
    expect(@principal.lookup_firm.subsidiaries).to have(1).item
    expect(@principal.firm.trading_names).to be_empty
  end

  def and_i_have_a_published_firm
    @firm = FactoryGirl.create(:firm)
    @principal.firm = @firm

    expect(@firm).to be_publishable
  end
  alias_method :and_i_have_publishable_firms, :and_i_have_a_published_firm

  def and_i_have_an_unpublished_firm
    @firm = @principal.firm

    expect(@firm).not_to be_publishable
  end
  alias_method :and_i_have_no_publishable_firms, :and_i_have_an_unpublished_firm

  def and_one_of_those_trading_names_is_unpublishable
    @unpublished_trading_name = @principal.firm.trading_names.first
    @unpublished_trading_name.offices = []
    expect(@unpublished_trading_name).not_to be_publishable
  end

  def and_one_of_those_trading_names_is_publishable
    @published_trading_name = @principal.firm.trading_names.first
    expect(@published_trading_name).to be_publishable
  end

  def and_i_am_logged_in
    login_as(@user, scope: :user)
  end
  alias_method :when_i_am_logged_in, :and_i_am_logged_in

  def when_i_am_on_the_principals_firms_index_page
    firms_index_page.load
    expect(firms_index_page).to be_displayed
  end
  alias_method :and_i_am_on_the_principals_firms_index_page, :when_i_am_on_the_principals_firms_index_page

  def then_i_am_on_the_principals_firms_index_page
    expect(firms_index_page).to be_displayed
  end

  def then_i_can_see_the_parent_firm_i_am_associated_with
    expect(firms_index_page).to have_parent_firm
    expect_firm_table_row(firms_index_page.parent_firm, @principal.firm)
  end

  def and_i_can_see_the_list_of_trading_names_i_am_associated_with
    expect(firms_index_page).to have_trading_names_block
    expect(firms_index_page).to have_trading_names(count: 3)

    trading_names = @principal.firm.trading_names.sorted_by_registered_name
    firms_index_page.trading_names.zip(trading_names).each do |trading_name_section, trading_name|
      expect_firm_table_row(trading_name_section, trading_name)
    end
  end

  def and_i_can_see_the_list_of_available_trading_names
    expect(firms_index_page).to have_available_trading_names_block
    expect(firms_index_page).to have_available_trading_names(count: 1)
    expect(firms_index_page.available_trading_names.first).to have_name(text: @lookup_trading_name.name)
  end

  def and_the_trading_names_block_is_not_shown
    expect(firms_index_page).not_to have_trading_names_block
  end

  def and_the_available_trading_names_block_is_not_shown
    expect(firms_index_page).not_to have_available_trading_names_block
  end

  def and_the_trading_names_section_is_showing_a_prompt_to_add_a_trading_name
    expect(firms_index_page).to have_trading_names_block
    expect(firms_index_page).to have_add_trading_names_prompt(
      text: I18n.t('self_service.firms_index.add_trading_names_prompt'))
    expect(firms_index_page).not_to have_trading_names
  end

  def when_i_remove_the_first_trading_name
    firms_index_page.trading_names.first.remove_button.click
  end

  def and_i_can_see_a_success_message
    expected_text = I18n.t!('self_service.trading_name_destroy.deleted', name: @trading_name_registered_name_to_delete)
    expect(firms_index_page).to have_flash_message(text: expected_text)
  end

  def and_i_can_see_the_first_trading_name
    @trading_name_registered_name_to_delete = firms_index_page.trading_names.first.name.text
    firms = firms_index_page.trading_names
    expect(firms.any? { |a| a.name.text == @trading_name_registered_name_to_delete }).to be_truthy
  end

  def and_i_cannot_see_the_deleted_trading_name
    firms = firms_index_page.trading_names
    expect(firms.any? { |a| a.name.text == @trading_name_registered_name_to_delete }).to be_falsey
  end

  def and_the_page_title_indicates_a_plural
    plural_form = I18n.t!('self_service.firms_index.title', count: 2)
    expect(firms_index_page.page_title).to have_text(/^#{plural_form}$/)
  end

  def and_the_page_title_indicates_a_singular
    singular_form = I18n.t!('self_service.firms_index.title', count: 1)
    expect(firms_index_page.page_title).to have_text(/^#{singular_form}$/)
  end

  def and_the_parent_firm_section_heading_is_visible
    expect(firms_index_page.parent_firm_heading)
      .to have_text(I18n.t!('self_service.firms_index.firm_heading'))
  end

  def and_the_parent_firm_section_heading_is_not_visible
    expect(firms_index_page).not_to have_parent_firm_heading
  end

  def and_i_should_see_the_overall_status_for_the_parent_firm
    expect(firms_index_page.parent_firm).to have_overall_status
  end

  def and_the_parent_firm_overall_status_is_unpublished
    expected_text = I18n.t!('self_service.firms_index.status.unpublished')
    expect(firms_index_page.parent_firm.overall_status).to have_text(expected_text)
    expect(firms_index_page.parent_firm).to have_unpublished
  end

  def and_the_parent_firm_overall_status_is_published
    expected_text = I18n.t!('self_service.firms_index.status.published')
    expect(firms_index_page.parent_firm.overall_status).to have_text(expected_text)
    expect(firms_index_page.parent_firm).to have_published
  end

  def then_i_can_see_the_status_of_the_trading_name
    expect(firms_index_page.trading_names.first).to have_overall_status
  end

  def and_the_trading_name_overall_status_is_unpublished
    expected_text = I18n.t!('self_service.firms_index.status.unpublished')
    trading_name = firms_index_page.trading_names.find do |tn|
      tn.name.text == @unpublished_trading_name.registered_name
    end

    expect(trading_name.overall_status).to have_text(expected_text)
    expect(trading_name).to have_unpublished
  end

  def and_the_trading_name_overall_status_is_published
    expected_text = I18n.t!('self_service.firms_index.status.published')
    trading_name = firms_index_page.trading_names.find do |tn|
      tn.name.text == @published_trading_name.registered_name
    end

    expect(trading_name.overall_status).to have_text(expected_text)
    expect(trading_name).to have_published
  end

  def then_i_can_see_the_onboading_message
    expect(firms_index_page).to have_onboarding_message
  end

  def then_i_can_not_see_the_onboading_message
    expect(firms_index_page).not_to have_onboarding_message
  end

  private

  def expect_firm_table_row(firm_row, firm)
    expect(firm_row).to have_frn(text: firm.fca_number)
    expect(firm_row).to have_name(text: firm.registered_name)
  end
end
