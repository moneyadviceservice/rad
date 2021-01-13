RSpec.feature 'Hiding Travel Insurance Firms', :inline_job_queue do
  include ActiveSupport::Testing::TimeHelpers
  include_context 'algolia index fake'

  let(:travel_insurance_firm_page) do
    Admin::TravelInsuranceFirmPage.new
  end

  let(:travel_insurance_firms_index_page) do
    Admin::TravelInsuranceFirmsIndexPage.new
  end

  let(:approved_at) { Time.utc(2021, 1, 6) }
  let(:hidden_at) { Time.utc(2021, 1, 7) }

  let!(:firm) {FactoryBot.create(:travel_insurance_firm, completed_firm: true, approved_at: approved_at)}

  scenario 'Hiding and unhiding a Firm' do
    given_there_are_registered_travel_insurance_firms
    when_i_visit_a_travel_insurance_firm_page
    and_the_firm_is_approved
    and_i_see_the_hide_button
    and_i_hide_the_firm
    then_the_firm_becomes_hidden
    and_the_firm_appears_hidden_in_the_firms_index
    # Now unhide the same firm
    when_i_visit_a_travel_insurance_firm_page
    and_i_see_the_unhide_button
    and_i_unhide_the_firm
    then_the_firm_is_visible
    and_the_firm_is_listed_as_approved_in_the_firms_index
  end

  def given_there_are_registered_travel_insurance_firms
    firm.reload
  end

  def when_i_visit_a_travel_insurance_firm_page
    travel_insurance_firm_page.load(firm_id: firm.id)
  end

  def and_the_firm_is_approved
    expect(firm.approved_at.blank?).to be_falsey
  end

  def and_i_see_the_hide_button
    expect(travel_insurance_firm_page).to have_hide_button
  end

  def and_i_see_the_unhide_button
    expect(travel_insurance_firm_page).to have_unhide_button
  end

  def and_i_hide_the_firm
    travel_to(hidden_at) do
      travel_insurance_firm_page.hide_button.click
    end
  end

  def and_i_unhide_the_firm
    travel_to(hidden_at) do
      travel_insurance_firm_page.unhide_button.click
    end
  end

  def then_the_firm_becomes_hidden
    expect(firm.reload.hidden_at.present?).to be true
  end

  def then_the_firm_is_visible
    expect(firm.reload.hidden_at.present?).to be_falsey
  end

  def and_the_firm_appears_hidden_in_the_firms_index
    travel_insurance_firms_index_page.load
    expect(travel_insurance_firms_index_page.approved_field.text).to eq("Hidden")
  end

  def and_the_firm_is_listed_as_approved_in_the_firms_index
    travel_insurance_firms_index_page.load
    expect(travel_insurance_firms_index_page.approved_field.text).to eq(approved_at.to_s(:short))
  end
end
