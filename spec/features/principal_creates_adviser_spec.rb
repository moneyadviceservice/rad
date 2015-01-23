RSpec.feature 'Principal creates Adviser', type: :request do
  let(:reference) { 'ABC12345' }
  let(:principal) { create(:principal) }
  let(:adviser_page) { AdviserPage.new }
  let(:adviser_confirmation_page) { AdviserConfirmationPage.new }

  let!(:qualifications) { create_list(:qualification, 2) }
  let!(:accreditations) { create_list(:accreditation, 2) }
  let!(:professional_standings) { create_list(:professional_standing, 2) }
  let!(:professional_bodies) { create_list(:professional_body, 2) }

  scenario 'Creating a valid Adviser' do
    given_i_have_created_a_firm
    when_i_provide_a_valid_adviser_reference_number
    and_the_adviser_is_matched
    and_i_provide_the_optional_qualifications
    and_i_provide_the_optional_accreditations
    and_i_provide_the_optional_statements_of_professional_standing
    and_i_provide_the_optional_professional_bodies
    and_i_have_confirmed_the_statement_of_truth
    when_i_submit_the_advisers_details
    then_the_adviser_is_assigned_to_the_firm
    and_i_receive_a_confirmation
    and_i_can_add_further_advisers
  end

  scenario 'Attempting to create an non-existent Adviser' do
    given_i_have_created_a_firm
    and_i_provide_a_valid_adviser_reference_number
    when_the_adviser_is_not_matched
    then_i_am_notified_of_this
    and_i_can_try_another_adviser_reference_number
  end

  scenario 'Matching an Adviser' do
    given_i_have_created_a_firm
    and_the_adviser_is_matched
    when_i_request_the_advisers_name
    then_the_endpoint_responds_ok
    and_i_am_given_the_advisers_name
  end


  def when_i_request_the_advisers_name
    get principal_lookup_adviser_path(principal, reference)
  end

  def then_the_endpoint_responds_ok
    expect(response).to be_ok
  end

  def and_i_am_given_the_advisers_name
    JSON.parse(response.body).tap do |json|
      expect(json['name']).to eq('Daisy Lovell')
    end
  end

  def when_the_adviser_is_not_matched
    adviser_page.submit.click
  end

  def then_i_am_notified_of_this
    expect(adviser_page).to be_adviser_unmatched
  end

  def and_i_can_try_another_adviser_reference_number
    expect(adviser_page.reference_number).to be_present
  end

  def given_i_have_created_a_firm
    expect(principal.firm).to be
  end

  def when_i_provide_a_valid_adviser_reference_number
    adviser_page.tap do |p|
      p.load(principal: principal.token)
      p.reference_number.set reference
    end
  end

  alias :and_i_provide_a_valid_adviser_reference_number :when_i_provide_a_valid_adviser_reference_number

  def and_the_adviser_is_matched
    @lookup_adviser = Lookup::Adviser.create!(
      reference_number: reference,
      name: 'Daisy Lovell'
    )
  end

  def and_i_provide_the_optional_qualifications
    qualifications.each { |q| adviser_page.check(q.name) }
  end

  def and_i_provide_the_optional_accreditations
    accreditations.each { |a| adviser_page.check(a.name) }
  end

  def and_i_provide_the_optional_statements_of_professional_standing
    professional_standings.each { |p| adviser_page.check(p.name) }
  end

  def and_i_provide_the_optional_professional_bodies
    professional_bodies.each { |p| adviser_page.check(p.name) }
  end

  def and_i_have_confirmed_the_statement_of_truth
    adviser_page.confirmed_disclaimer.set true
  end

  def when_i_submit_the_advisers_details
    adviser_page.submit.click
  end

  def then_the_adviser_is_assigned_to_the_firm
    Adviser.find_by(reference_number: reference).tap do |a|
      expect(a.firm).to be
      expect(a.qualifications).to_not be_empty
      expect(a.accreditations).to_not be_empty
      expect(a.professional_standings).to_not be_empty
      expect(a.professional_bodies).to_not be_empty
    end
  end

  def and_i_receive_a_confirmation
    expect(adviser_confirmation_page).to be_displayed
  end

  def and_i_can_add_further_advisers
    adviser_confirmation_page.add_another.click

    expect(adviser_page).to be_displayed
  end
end
