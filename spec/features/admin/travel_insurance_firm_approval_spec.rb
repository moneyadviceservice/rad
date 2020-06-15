RSpec.feature 'Approving travel insurance firms', :inline_job_queue do
  include ActiveSupport::Testing::TimeHelpers

  let(:travel_insurance_firm_page) do
    Admin::TravelInsuranceFirmPage.new
  end

  let(:travel_insurance_firms_index_page) do
    Admin::TravelInsuranceFirmsIndexPage.new
  end

  let(:approval_date) { Time.utc(2019, 6, 1) }

  scenario 'Approving a travel insurance firm' do
    given_there_are_registered_travel_insurance_firms
    when_i_visit_a_travel_insurance_firm_page
    and_i_approve_the_firm
    then_the_firm_becomes_approved
    and_i_dont_see_the_approve_button
    and_the_firm_is_listed_as_approved_in_the_firms_index
  end

  def given_there_are_registered_travel_insurance_firms
    user = FactoryBot.create(:user)
    @firm = FactoryBot.create(
      :travel_insurance_firm,
      fca_number: user.principal.fca_number,
      approved_at: nil
    )
  end

  def when_i_visit_a_travel_insurance_firm_page
    travel_insurance_firm_page.load(firm_id: @firm.id)
  end

  def and_i_approve_the_firm
    travel_to(approval_date) do
      travel_insurance_firm_page.approve_button.click
    end
  end

  def then_the_firm_becomes_approved
    expect(
      travel_insurance_firm_page.approved.text
    ).to eq("Approved: #{approval_date.to_s(:long)}")
    expect(@firm.reload.approved_at).to_not be_nil
  end

  def and_i_dont_see_the_approve_button
    expect(travel_insurance_firm_page).not_to have_approve_button
  end

  def and_the_firm_is_listed_as_approved_in_the_firms_index
    travel_insurance_firms_index_page.load
    expect(travel_insurance_firms_index_page.total_firms).to eq(1)
    expect(
      travel_insurance_firms_index_page.firms.map(&:approved)
    ).to eq([approval_date.to_s(:short)])
  end
end
