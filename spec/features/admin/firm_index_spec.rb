RSpec.feature 'Viewing firms on the admin interface' do
  let(:the_page) { Admin::FirmsIndexPage.new }

  before do
    given_there_are_firms
    given_i_am_on_the_admin_firms_index_page
    then_i_see_all_firms
  end

  scenario 'Identifying firms with unverified fca numbers' do
    then_i_see_firms_with_unverified_fca_numbers
  end

  def given_i_am_on_the_admin_firms_index_page
    the_page.load
    expect(the_page).to be_displayed
    expect_no_errors
  end

  def given_there_are_firms
    @verified_principals = 4.times.map{|n| FactoryGirl.create(:principal, fca_verified: true) }
    @un_verified_principals = 4.times.map{|n| FactoryGirl.create(:principal) }
  end

  def then_i_see_all_firms
    total_firms = (@verified_principals + @un_verified_principals).map(&:firm)

    expect(the_page.total_firms).to eq(total_firms.count)
    expect(the_page.firms.count).to eq(total_firms.count)
  end

  def expect_no_errors
    return unless status_code == 500
    expect(the_page).not_to have_text %r{[Ee]rror|[Ww]arn|[Ee]xception}
  end

  def then_i_see_firms_with_unverified_fca_numbers
    expect(the_page.fca_unverified_firms.count).to eq(@un_verified_principals.count)
  end
end
