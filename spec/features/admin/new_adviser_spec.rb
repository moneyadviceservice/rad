RSpec.feature 'Add a new adviser without an FCA number',
              vcr: vcr_options_for(:features_admin_advisers_add_spec) do
  let(:firm_page) { Admin::FirmPage.new }
  let(:new_adviser_page) { Admin::NewAdviserPage.new }

  before do
    given_there_is_a_firm
    when_i_visit_the_firm_admin_page
    then_there_should_be_no_advisers

    when_i_click_the_new_adviser_button
    then_i_am_on_the_new_adviser_page
  end

  scenario 'Adding an adviser' do
    when_i_complete_the_form
    and_i_click_save

    then_i_am_on_the_firm_page
    and_i_can_see_1_adviser
    and_they_have_been_geocoded
  end

  scenario 'Adding an adviser after we fail once' do
    when_i_click_save
    then_there_are_validation_errors
    and_i_am_still_on_the_page

    when_i_complete_the_form
    and_i_click_save

    then_i_am_on_the_firm_page
    then_no_errors_are_displayed_on(the_page: firm_page)
    and_i_can_see_1_adviser
  end

  def given_there_is_a_firm
    @firm = FactoryGirl.create(:firm_with_principal, :without_advisers)
  end

  def when_i_visit_the_firm_admin_page
    firm_page.load(firm_id: @firm.id)
    expect(firm_page).to be_displayed
    then_no_errors_are_displayed_on(the_page: firm_page)
  end

  def then_there_should_be_no_advisers
    expect(firm_page.advisers.count).to eq(0)
  end

  def when_i_click_the_new_adviser_button
    firm_page.new_adviser.click
  end

  def then_i_am_on_the_new_adviser_page
    expect(new_adviser_page).to be_displayed
    then_no_errors_are_displayed_on(the_page: new_adviser_page)
  end

  def when_i_complete_the_form
    new_adviser_page.name.set 'Example Adviser'
    new_adviser_page.postcode.set 'EH1 2AS'
    new_adviser_page.travel_distance.select '10 miles'
  end

  def and_i_click_save
    new_adviser_page.save.click
  end

  def when_i_click_save
    new_adviser_page.save.click
  end

  def then_there_are_validation_errors
    expect(new_adviser_page).to have_errors
  end

  def and_i_am_still_on_the_page
    expect(new_adviser_page).to be_displayed
    then_no_errors_are_displayed_on(the_page: new_adviser_page)
  end

  def then_i_am_on_the_firm_page
    expect(firm_page).to be_displayed
    then_no_errors_are_displayed_on(the_page: firm_page)
  end

  def and_i_can_see_1_adviser
    expect(firm_page.advisers.count).to eq(1)
  end

  def and_they_have_been_geocoded
    expect(@firm.advisers.first).to be_geocoded
  end

  def then_no_errors_are_displayed_on(the_page:)
    # Matching only on title-case 'Error' as the word 'error' appears in the
    # validation message preamble
    # expect(the_page).not_to have_text %r{Error|[Ww]arn|[Ee]xception}

    puts the_page.text if the_page.status_code == 500

    expect(the_page.status_code).not_to eq(500)
  end
end
