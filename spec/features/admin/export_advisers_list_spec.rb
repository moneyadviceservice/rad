# Feature: Advisors list export
#  As the person maintaining the RAD database.
#  In order to get rid of unwanted advisors.
#  I need to be able to cross reference a large list (4k) of unauthorised advisers against records in the RAD database.
#  The list needs to be cleared up so customers do not get sent to unapproved advisers and RAD maintain it's credibility.
#

RSpec.feature 'registered advisors report' do
  let(:admin_page) { Admin::IndexPage.new }
  let(:registered_adviser_show_page) { Admin::RegisteredAdviserShowPage.new }

  before do
    given_i_am_a_fully_registered_principal_user
    and_i_am_logged_in_as_an_admin
  end

  scenario 'no registered advisers' do
    and_there_are_no_registered_advisers
    when_i_visit_the_registered_adviser_page
    then_i_should_not_see_any_registered_advisers
  end

  scenario 'has registered advisers' do
    and_there_exists_registered_advisors
    when_i_visit_the_registered_adviser_page
    then_i_should_see_all_registered_advisers
  end

  scenario 'blocks download as CSV' do
    and_there_are_no_registered_advisers
    when_i_visit_the_registered_adviser_page
    then_i_should_not_be_able_to_download
  end

  scenario 'permits download as CSV' do
    Timecop.freeze Date.new(2017, 05, 30) do
      and_there_exists_registered_advisors
      when_i_visit_the_registered_adviser_page
      and_click_on_download_as_csv_button
      then_i_should_have_a_file_with_all_registered_advisers
    end
  end

  def given_i_am_a_fully_registered_principal_user
    @principal = FactoryGirl.create :principal
    @user = FactoryGirl.create :user, principal: @principal
  end

  def and_i_am_logged_in_as_an_admin
    login_as(@user, scope: :admin)
    admin_page.load
    expect(page).to have_content 'RAD Administration'
  end

  def when_i_visit_the_registered_adviser_page
    registered_adviser_show_page.load
  end

  def and_there_are_no_registered_advisers
    Adviser.delete_all
  end

  def then_i_should_not_see_any_registered_advisers
    expect(registered_adviser_show_page).to have_content('No advisers to display')
  end

  def and_there_exists_registered_advisors
    firm = FactoryGirl.create(:firm, registered_name: 'James Andrews Investment PLC')
    FactoryGirl.create(:adviser,
                       name: 'James Andrews',
                       reference_number: 'ABC12345',
                       firm: firm)
  end

  def then_i_should_see_all_registered_advisers
    expect(registered_adviser_show_page).to have_content('ABC12345')
    expect(registered_adviser_show_page).to have_content('James Andrews')
    expect(registered_adviser_show_page).to have_content('James Andrews Investment PLC')
  end

  def and_click_on_download_as_csv_button
    click_on 'Download as CSV'
  end

  def then_i_should_have_a_file_with_all_registered_advisers
    filename = 'registered_advisers_2017-05-30.csv'

    expect(registered_adviser_show_page.response_headers['Content-Type']).to eq('text/csv')
    expect(registered_adviser_show_page.response_headers['Content-Disposition']).to eq("attachment; filename=#{filename}")
    expect(registered_adviser_show_page).to_not have_content('Registered Advisers')
  end

  def then_i_should_not_be_able_to_download
    expect(registered_adviser_show_page).to_not have_content('Download as CSV')
  end
end
