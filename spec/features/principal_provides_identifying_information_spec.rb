RSpec.feature 'Principal provides identifying information' do
  let(:identification_page) { IdentificationPage.new }
  let(:identity_confirmed_page) { IdentityConfirmedPage.new }

  scenario 'Identifying as a Firm Principal' do
    given_i_have_passed_the_pre_qualification_step
    when_i_provide_my_firms_fca_reference_number
    and_i_provide_my_identifying_particulars
    then_my_firms_fca_reference_number_is_matched_to_the_directory
    and_i_am_shown_a_confirmation_message
    and_i_am_sent_a_verification_email
  end

  scenario 'My FCA number cannot be matched' do
    given_i_have_passed_the_pre_qualification_step
    when_i_provide_a_valid_but_unmatched_fca_number
    then_i_am_told_my_firms_details_are_not_present
    and_i_am_asked_to_contact_admin_if_i_have_any_queries
  end


  def given_i_have_passed_the_pre_qualification_step
    identification_page.load
  end

  def when_i_provide_a_valid_but_unmatched_fca_number
    identification_page.tap do |p|
      p.reference_number.set '654321'
      p.email_address.set 'ben@example.com'
      p.register.click
    end
  end

  def then_i_am_told_my_firms_details_are_not_present
    expect(identification_page).to be_firm_unmatched
  end

  def and_i_am_asked_to_contact_admin_if_i_have_any_queries
    skip
  end

  def when_i_provide_my_firms_fca_reference_number
    identification_page.reference_number.set '123456'
  end

  def and_i_provide_my_identifying_particulars
    identification_page.tap do |p|
      p.website_address.set 'www.example.com'
      p.first_name.set 'Ben'
      p.last_name.set 'Lovell'
      p.job_title.set 'Director'
      p.email_address.set 'ben@example.com'
      p.telephone_number.set '07715 930 400'
      p.confirmation.set true
    end
  end

  def then_my_firms_fca_reference_number_is_matched_to_the_directory
    Lookup::Firm.create!(fca_number: '123456', registered_name: 'Ben Lovell Ltd')

    identification_page.register.click
  end

  def and_i_am_shown_a_confirmation_message
    expect(identity_confirmed_page).to be_displayed
  end

  def and_i_am_sent_a_verification_email
    expect(ActionMailer::Base.deliveries).to_not be_empty
  end
end
