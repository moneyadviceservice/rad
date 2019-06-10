RSpec.feature 'Approving firms on the admin interface' do
  include ActiveSupport::Testing::TimeHelpers

  let(:index_page) { Admin::FirmsIndexPage.new }
  let(:firm_page) { Admin::FirmPage.new }
  let(:approval_date) { Time.utc(2019, 6, 1) }

  scenario 'Approving a Firm' do
    given_there_are_fully_registered_principal_users
    given_i_am_at_the_admin_firms_index_page
    then_i_see_all_firms
    then_all_firms_are_not_approved
    when_i_visit_a_firm_page(@firms.first)
    then_i_see_the_firm_is_not_approved

    travel_to(approval_date) do
      when_i_approve_the_firm
    end

    then_the_firm_becomes_approved
    then_i_dont_see_the_approve_button
    then_the_firm_is_listed_as_approved_in_the_index(@firms.first)
  end

  def given_i_am_at_the_admin_firms_index_page
    index_page.load
    expect(index_page).to be_displayed
    expect_no_errors
  end

  def given_there_are_fully_registered_principal_users
    @users = FactoryGirl.create_list(:user, 2)
    @principals = @users.map(&:principal)
    @firms = @principals.map(&:firm)
  end

  def then_i_see_all_firms
    expect(index_page.total_firms).to eq(@firms.count)
    expect(index_page.firms.count).to eq(@firms.count)
  end

  def then_all_firms_are_not_approved
    expect(index_page.firms.map(&:approved)).to rspec_all(eq('Not approved'))
  end

  def expect_no_errors
    return unless status_code == 500
    expect(index_page).not_to have_text %r{[Ee]rror|[Ww]arn|[Ee]xception}
  end

  def when_i_visit_a_firm_page(firm)
    firm_page.load(firm_id: firm.id)
    expect(firm_page).to be_displayed
    expect_no_errors
  end

  def then_i_see_the_firm_is_not_approved
    expect(firm_page.approved.text).to eq('Approved: Not approved')
  end

  def when_i_approve_the_firm
    firm_page.approve_button.click
  end

  def then_the_firm_becomes_approved
    expect(firm_page.approved.text)
      .to eq("Approved: #{approval_date.to_s(:long)}")
  end

  def then_i_dont_see_the_approve_button
    expect(firm_page).not_to have_approve_button
  end

  def then_the_firm_is_listed_as_approved_in_the_index(approved_firm)
    index_page.load
    expect(index_page).to be_displayed
    expect_no_errors

    firm_info = index_page.firms.select do |firm|
                  firm.fca_number.to_s == approved_firm.fca_number.to_s
                end.first
    expect(firm_info.approved).to eq approval_date.to_s(:short)
  end
end
