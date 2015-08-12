RSpec.feature 'The self service firm offices list page' do
  let(:offices_index_page) { SelfService::OfficesIndexPage.new }
  let(:sign_in_page) { SignInPage.new }

  let(:principal) { FactoryGirl.create(:principal) }
  let(:user) { FactoryGirl.create(:user, principal: principal) }

  scenario 'The page requires authentication to access' do
    when_i_navigate_to_the_offices_page_for_my_firm
    then_i_see(the_page: sign_in_page)
  end

  scenario 'We can get to the offices page for a given firm' do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in
    when_i_navigate_to_the_offices_page_for_my_firm
    then_i_see(the_page: offices_index_page)
    then_no_errors_are_displayed_on(the_page: offices_index_page)
    then_i_see_the_firm_name_in_the_page_title
  end

  def given_i_am_a_fully_registered_principal_user
    firm_attrs = FactoryGirl.attributes_for(:firm, fca_number: principal.fca_number)
    principal.firm.update_attributes(firm_attrs)
    expect(Firm.registered.find(principal.firm.id)).to be_present
  end

  def and_i_am_logged_in
    login_as(user, scope: :user)
  end

  def when_i_navigate_to_the_offices_page_for_my_firm
    offices_index_page.load(firm_id: principal.firm.id)
  end

  def then_i_see(the_page:)
    expect(the_page).to be_displayed
  end

  def then_no_errors_are_displayed_on(the_page:)
    expect(the_page).not_to have_text %r{[Ee]rror|[Ww]arn|[Ee]xception}
    expect(the_page.status_code).not_to eq(500)
  end

  def then_i_see_the_firm_name_in_the_page_title
    expect(offices_index_page.page_title).to have_text(principal.firm.registered_name)
  end
end
