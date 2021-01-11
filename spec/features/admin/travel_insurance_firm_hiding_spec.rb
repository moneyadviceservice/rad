RSpec.feature 'Hiding travel insurance firms', :inline_job_queue do
  include ActiveSupport::Testing::TimeHelpers
  include_context 'algolia index fake'

  let(:travel_insurance_firm_page) do
    Admin::TravelInsuranceFirmPage.new
  end

  let(:travel_insurance_firms_index_page) do
    Admin::TravelInsuranceFirmsIndexPage.new
  end

  let(:hidden_at) { Time.utc(2021, 1, 6) }

  scenario 'Hiding a Firm' do
    given_there_are_approved_travel_insurance_firms
    when_i_visit_a_travel_insurance_firm_page
    and_i_see_the_hide_button
    and_i_hide_the_firm
    then_the_firm_becomes_hidden
    and_i_see_the_unhide_button
    and_the_firm_is_listed_as_hidden_in_the_firms_index
  end

  def given_there_are_approved_travel_insurance_firms
    @firm = FactoryBot.create(:travel_insurance_firm,
      completed_firm: true)
    @user = FactoryBot.create(:user, principal: @firm.principal)
  end

  def when_i_visit_a_travel_insurance_firm_page
    travel_insurance_firm_page.load(firm_id: @firm.id)
  end

  def and_i_see_the_hide_button
    expect(travel_insurance_firm_page).to have_hide_button
  end

  def and_i_see_the_unhide_button
    expect(travel_insurance_firm_page).not_to have_unhide_button
  end

  def and_i_hide_the_firm
    travel_to(hidden_at) do
      travel_insurance_firm_page.hide_button.click
    end
  end

  def then_the_firm_becomes_hidden
    expect(@firm.reload.hidden?).to be_true
  end

  def and_the_firm_is_listed_as_hidden_in_the_firms_index
    travel_insurance_firms_index_page.load
    expect(travel_insurance_firms_index_page.total_firms).to eq(1)
    expect(
      travel_insurance_firms_index_page.firms.map(&:hidden)
    ).to eq(1)
  end

  def then_the_travel_insurance_firm_and_offerings_gets_pushed_to_the_directory
    directory_travel_firms = travel_firms_in_directory
    directory_travel_firm_offerins = travel_firm_offerings_in_directory

    aggregate_failures 'firm info in directory' do
      expect(directory_travel_firms.map { |firm| firm['objectID'] })
        .to eq [@firm.id]

      expect(directory_travel_firm_offerins.map { |offerings| offerings['objectID'] })
        .to eq @firm.trip_covers.pluck(:id)
    end
  end

end
