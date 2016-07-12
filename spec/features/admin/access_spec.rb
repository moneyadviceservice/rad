RSpec.feature 'Accessing the admin area' do
  let(:admin_adviser_page) { AdminAdviserPage.new }
  let(:username) { 'admin' }
  let(:password) { 'password' }

  before do
    allow(HttpAuthentication).to receive(:username) { username }
    allow(HttpAuthentication).to receive(:password) { password }
  end

  scenario 'Not needing to authenticate' do
    given_i_am_not_required_to_authenticate_to_access_admin
    when_i_visit_the_admin_home_page
    then_i_am_granted_access
  end

  scenario 'Successfully authenticating' do
    given_i_am_required_to_authenticate_to_access_admin
    and_i_authenticate_with_valid_credentials
    when_i_visit_the_admin_home_page
    then_i_am_granted_access
  end

  scenario 'Unsuccessfully authenticating' do
    given_i_am_required_to_authenticate_to_access_admin
    and_i_authenticate_with_invalid_credentials
    when_i_visit_the_admin_home_page
    then_i_am_denied_access
  end

  def given_i_am_required_to_authenticate_to_access_admin
    allow(HttpAuthentication).to receive(:required?) { true }
  end

  def given_i_am_not_required_to_authenticate_to_access_admin
    allow(HttpAuthentication).to receive(:required?) { false }
  end

  def and_i_authenticate_with_valid_credentials
    page.driver.browser.basic_authorize(username, password)
  end

  def and_i_authenticate_with_invalid_credentials
    page.driver.browser.basic_authorize(username, password.reverse)
  end

  def when_i_visit_the_admin_home_page
    visit(admin_root_path)
  end

  def then_i_am_granted_access
    expect(page.status_code).to eq(200)
  end

  def then_i_am_denied_access
    expect(page.status_code).to eq(401)
  end
end
