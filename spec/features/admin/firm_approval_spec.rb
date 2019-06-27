RSpec.feature 'Approving firms on the admin interface', :inline_job_queue do
  include ActiveSupport::Testing::TimeHelpers
  include_context 'algolia directory double'

  let(:index_page) { Admin::FirmsIndexPage.new }
  let(:firm_page) { Admin::FirmPage.new }
  let(:approval_date) { Time.utc(2019, 6, 1) }

  scenario 'Approving a Firm' do
    given_there_are_fully_registered_principal_users_with_advisers_and_offices
    given_i_am_at_the_admin_firms_index_page
    then_i_see_all_firms
    then_all_firms_are_not_approved
    and_no_advisers_or_offices_are_present_in_the_directory

    when_i_visit_a_firm_page(@firms.first)
    then_i_see_the_firm_is_not_approved

    travel_to(approval_date) do
      when_i_approve_the_firm
    end

    then_the_firm_becomes_approved
    then_the_firm_advisers_and_offices_get_pushed_to_the_directory(@firms.first)
    then_i_dont_see_the_approve_button
    then_the_firm_is_listed_as_approved_in_the_firms_index(@firms.first)
  end

  def given_i_am_at_the_admin_firms_index_page
    index_page.load
    expect(index_page).to be_displayed
    expect_no_errors
  end

  def given_there_are_fully_registered_principal_users_with_advisers_and_offices
    @users = FactoryGirl.create_list(:user, 2)
    @principals = @users.map(&:principal)
    @firms = @principals.map(&:firm)
    @firms.each do |firm|
      firm.advisers << FactoryGirl.create(:adviser, firm: firm)
      firm.offices << FactoryGirl.create(:office, firm: firm)
    end
  end

  def then_i_see_all_firms
    expect(index_page.total_firms).to eq(@firms.count)
    expect(index_page.firms.count).to eq(@firms.count)
  end

  def then_all_firms_are_not_approved
    expect(index_page.firms.map(&:approved)).to rspec_all(eq('Not approved'))
  end

  def and_no_advisers_or_offices_are_present_in_the_directory
    aggregate_failures 'empty directory' do
      @firms.each do |firm|
        expect(firm_advisers_in_directory(firm)).to be_empty
        expect(firm_offices_in_directory(firm)).to be_empty
      end
    end
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

  def then_the_firm_is_listed_as_approved_in_the_firms_index(approved_firm)
    index_page.load
    expect(index_page).to be_displayed
    expect_no_errors

    firm_info = index_page.firms.select do |firm|
                  firm.fca_number.to_s == approved_firm.fca_number.to_s
                end.first
    expect(firm_info.approved).to eq approval_date.to_s(:short)
  end

  def then_the_firm_advisers_and_offices_get_pushed_to_the_directory(firm)
    directory_advisers = firm_advisers_in_directory(firm)
    directory_offices = firm_offices_in_directory(firm)

    aggregate_failures 'firm info in directory' do
      expect(directory_advisers.map { |adviser| adviser['objectID'] })
        .to eq firm.advisers.pluck(:id)
      expect(directory_offices.map { |office| office['objectID'] })
        .to eq firm.offices.pluck(:id)
    end
  end
end
