RSpec.feature 'The registration status' do
  let(:firms_index_page) { SelfService::FirmsIndexPage.new }
  let(:firm_edit_page)   { SelfService::FirmEditPage.new }

  before do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in
    when_i_am_on_the_firms_page
  end

  scenario 'Firm has not yet filled in details for the selected firm' do
    and_i_have_an_invalid_firm
    and_i_click_the_edit_link_for_my_firm

    then_i_see_the_edit_page_for_my_firm
    and_i_can_see_the_overall_status_panel
    and_i_see_a_status_item_for_adding_firm_details
    and_i_see_an_exclamation_mark_on_firm_details
    and_i_do_not_see_validation_errors
  end

  scenario 'Firm has filled in details for the selected firm' do
    and_i_have_a_valid_firm
    and_i_click_the_edit_link_for_my_firm

    then_i_see_the_edit_page_for_my_firm
    and_i_can_see_the_overall_status_panel
    and_i_do_not_see_a_status_item_for_adding_firm_details
    and_i_do_not_see_an_exclamation_mark_on_firm_details
  end

  scenario 'Firm has no advisers' do
    and_i_have_a_firm
    and_i_have_a_firm_without_advisers
    and_i_click_the_edit_link_for_my_firm

    then_i_see_the_edit_page_for_my_firm
    and_i_can_see_the_overall_status_panel
    and_i_see_a_status_item_for_adding_advisers
    and_i_see_an_exclamation_mark_on_advisers
  end

  scenario 'Firm has advisers' do
    and_i_have_a_firm
    and_i_have_a_firm_with_advisers
    and_i_click_the_edit_link_for_my_firm

    then_i_see_the_edit_page_for_my_firm
    and_i_can_see_the_overall_status_panel
    and_i_do_not_see_a_status_item_for_adding_advisers
    and_i_do_not_see_an_exclamation_mark_on_advisers
  end

  scenario 'Firm has no offices' do
    and_i_have_a_firm
    and_i_have_a_firm_without_offices
    and_i_click_the_edit_link_for_my_firm

    then_i_see_the_edit_page_for_my_firm
    and_i_can_see_the_overall_status_panel
    and_i_see_a_status_item_for_adding_offices
    and_i_see_an_exclamation_mark_on_offices
  end

  scenario 'Firm has offices' do
    and_i_have_a_firm
    and_i_have_a_firm_with_offices
    and_i_click_the_edit_link_for_my_firm

    then_i_see_the_edit_page_for_my_firm
    and_i_can_see_the_overall_status_panel
    and_i_do_not_see_a_status_item_for_adding_offices
    and_i_do_not_see_an_exclamation_mark_on_offices
  end

  def given_i_am_a_fully_registered_principal_user
    @principal = FactoryBot.create(:principal)
    @user = FactoryBot.create(:user, principal: @principal)
  end

  def and_i_have_a_firm
    firm_attrs = FactoryBot.attributes_for(:firm, fca_number: @principal.fca_number)
    @principal.firm.update(firm_attrs)
    @principal.firm.website_address
  end
  alias_method :and_i_have_a_firm_without_advisers, :and_i_have_a_firm
  alias_method :and_i_have_a_firm_without_offices, :and_i_have_a_firm

  def and_i_have_a_valid_firm
    and_i_have_a_firm
    expect(@principal.firm).to be_valid
  end

  def and_i_have_an_invalid_firm
    expect(@principal.firm).not_to be_valid
  end

  def and_i_am_logged_in
    login_as(@user, scope: :user)
  end

  def when_i_am_on_the_firms_page
    firms_index_page.load
    expect(firms_index_page).to be_displayed
  end

  def and_i_have_a_firm_with_advisers
    @principal.firm.update(advisers: FactoryBot.create_list(:adviser, 1))
  end

  def and_i_have_a_firm_with_offices
    FactoryBot.create(:office, officeable: @principal.firm)
  end

  def and_i_have_a_firm_with_advisers_and_offices
    and_i_have_a_firm_with_advisers
    and_i_have_a_firm_with_offices
  end

  def and_i_click_the_edit_link_for_my_firm
    firms_index_page.parent_firm.edit_link.click
  end

  def then_i_see_the_edit_page_for_my_firm
    expect(firm_edit_page).to be_displayed
    expect(firm_edit_page.firm_name).to have_text @principal.firm.registered_name
  end

  def and_i_can_see_the_overall_status_panel
    expect(firm_edit_page).to have_overall_status_panel
  end

  def and_i_see_a_status_item_for_adding_firm_details
    expect(firm_edit_page.overall_status_panel).to have_text I18n.t('self_service.status.needs_firm_details')
  end

  def and_i_see_a_status_item_for_adding_advisers
    expect(firm_edit_page.overall_status_panel).to have_text I18n.t('self_service.status.needs_advisers')
  end

  def and_i_see_a_status_item_for_adding_offices
    expect(firm_edit_page.overall_status_panel).to have_text I18n.t('self_service.status.needs_offices')
  end

  def and_i_do_not_see_a_status_item_for_adding_firm_details
    expect(firm_edit_page.overall_status_panel).not_to have_text I18n.t('self_service.status.needs_firm_details')
  end

  def and_i_do_not_see_a_status_item_for_adding_advisers
    expect(firm_edit_page.overall_status_panel).not_to have_text I18n.t('self_service.status.needs_advisers')
  end

  def and_i_do_not_see_a_status_item_for_adding_offices
    expect(firm_edit_page.overall_status_panel).not_to have_text I18n.t('self_service.status.needs_offices')
  end

  def and_i_see_an_exclamation_mark_on_firm_details
    expect(firm_edit_page).to have_firm_details_exclamation
  end

  def and_i_see_an_exclamation_mark_on_advisers
    expect(firm_edit_page).to have_adviser_exclamation
  end

  def and_i_see_an_exclamation_mark_on_offices
    expect(firm_edit_page).to have_office_exclamation
  end

  def and_i_do_not_see_an_exclamation_mark_on_firm_details
    expect(firm_edit_page).not_to have_firm_details_exclamation
  end

  def and_i_do_not_see_an_exclamation_mark_on_advisers
    expect(firm_edit_page).not_to have_adviser_exclamation
  end

  def and_i_do_not_see_an_exclamation_mark_on_offices
    expect(firm_edit_page).not_to have_office_exclamation
  end

  def and_i_do_not_see_validation_errors
    expect(firm_edit_page).to_not have_validation_summary
  end
end
