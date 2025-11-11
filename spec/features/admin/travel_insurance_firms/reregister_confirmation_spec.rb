RSpec.feature 'Approval of reregistered travel insurance firms', :inline_job_queue do
  include_context 'algolia index fake'

  let(:travel_insurance_firm_page) do
    Admin::TravelInsuranceFirmPage.new
  end

  scenario 'Successfully approving a reregistered travel insurance firm' do
    given_there_are_unapproved_travel_insurance_firms
    when_i_visit_a_travel_insurance_firm_page
    and_i_approve_the_firm
    then_the_firm_becomes_approved
    and_i_dont_see_the_approve_button
  end

  def given_there_are_unapproved_travel_insurance_firms
    @firm = FactoryBot.create(:travel_insurance_firm, completed_firm: true, reregistered_at: Time.zone.now)
  end

  def when_i_visit_a_travel_insurance_firm_page
    travel_insurance_firm_page.load(firm_id: @firm.id)
  end

  def and_i_approve_the_firm
    travel_insurance_firm_page.reregister_approve.click
  end

  def then_the_firm_becomes_approved
    expect(@firm.reload).to be_reregister_approved_at

    expect(travel_insurance_firm_page.reregister_approved_label).to have_text("Reregistration Approved: #{@firm.reregister_approved_at.to_s(:long)}")
  end

  def and_i_dont_see_the_approve_button
    expect(travel_insurance_firm_page).not_to have_reregister_approve
  end
end
