RSpec.feature 'Principal creates Adviser' do
  let(:principal) { create(:principal) }
  let(:adviser_page) { AdviserPage.new }

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


  def given_i_have_created_a_firm
    expect(principal.firm).to be
  end

  def when_i_provide_a_valid_adviser_reference_number
    adviser_page.tap do |p|
      p.load(principal: principal.token)
      p.reference_number.set 'ABCD1234'
    end
  end

  def and_the_adviser_is_matched
    skip
  end

  def and_i_provide_the_optional_qualifications
    skip
  end

  def and_i_provide_the_optional_accreditations
    skip
  end

  def and_i_provide_the_optional_statements_of_professional_standing
    skip
  end

  def and_i_provide_the_optional_professional_bodies
    skip
  end

  def and_i_have_confirmed_the_statement_of_truth
    skip
  end

  def when_i_submit_the_advisers_details
    skip
  end

  def then_the_adviser_is_assigned_to_the_firm
    skip
  end

  def and_i_receive_a_confirmation
    skip
  end

  def and_i_can_add_further_advisers
    skip
  end
end
