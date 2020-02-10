RSpec.feature 'Principal provides identifying information', :inline_job_queue do
  let(:identification_page) { IdentificationPage.new }
  let(:thank_you_for_registering_page) { ThankYouForRegisteringPage.new }
  let(:firms_index_page) { SelfService::FirmsIndexPage.new }
  let(:sign_in_page) { SignInPage.new }

  before { ActionMailer::Base.deliveries.clear }

  scenario 'Identifying as a Firm Principal' do
    given_i_have_passed_the_pre_qualification_step
    when_i_provide_my_firms_fca_reference_number
    and_i_provide_my_identifying_particulars
    then_i_am_shown_a_thank_you_for_registering_message
    and_i_later_receive_an_email_confirming_my_registration
  end

  scenario 'I provide invalid information' do
    given_i_have_passed_the_pre_qualification_step
    when_i_provide_incorrect_or_invalid_information
    then_i_am_told_which_fields_are_incorrect_and_why
  end

  def given_i_have_passed_the_pre_qualification_step
    identification_page.load
  end

  def when_i_provide_incorrect_or_invalid_information
    identification_page.tap do |p|
      p.email.set 'welp'
      p.first_name.set ''
      p.last_name.set ''
      p.telephone_number.set 'welp'
      p.confirmation.set false
      p.register.click
    end
  end

  def then_i_am_told_which_fields_are_incorrect_and_why
    expect(identification_page).to have_validation_summaries
  end

  def when_i_provide_a_valid_but_unmatched_fca_number
    identification_page.tap do |p|
      p.reference_number.set '654321'
      p.email.set 'ben@example.com'
      p.register.click
    end
  end

  def then_i_am_told_my_firms_details_are_not_present
    expect(identification_page).to be_firm_unmatched
  end

  def and_i_am_asked_to_contact_admin_if_i_have_any_queries
    expect(identification_page).to be_errored
  end

  def when_i_provide_my_firms_fca_reference_number
    identification_page.reference_number.set '311244'
  end

  def and_i_provide_my_identifying_particulars
    identification_page.tap do |p|
      p.first_name.set 'Ben'
      p.last_name.set 'Lovell'
      p.job_title.set 'Director'
      p.email.set 'ben@moneyadviceservice.org.uk'
      p.password.set 'Password1!'
      p.password_confirmation.set 'Password1!'
      p.telephone_number.set '07715 930 400'

      p.confirmation.set true

      VCR.use_cassette('registrations_fca_firm_api_call') do
        p.register.click
      end
    end
  end

  def and_i_later_receive_an_email_confirming_my_registration
    expect(
      ActionMailer::Base.deliveries.find do |mail|
        mail.subject.match?(/Your Directory Account/)
      end
    ).to_not be_nil
  end

  def then_i_am_shown_a_thank_you_for_registering_message
    expect(thank_you_for_registering_page).to have_content(
      I18n.t('success.heading')
    )
    expect(thank_you_for_registering_page).to have_content(
      I18n.t('success.message')
    )
  end

  def and_i_am_sent_a_verification_email
    expect(ActionMailer::Base.deliveries).to_not be_empty
    expect(ActionMailer::Base.deliveries.first.body).to include new_user_session_path
  end

  def and_directory_admins_get_a_new_firm_notification_email
    expect(ActionMailer::Base.deliveries).to_not be_empty

    last_email = ActionMailer::Base.deliveries.last
    expect(last_email.subject).to eq('New Firm registered in the directory')
    expect(last_email.to).to include('dev@moneyadviceservice.org.uk')
    expect(last_email.body).to include('Ben Lovell Ltd')
    expect(last_email.body).to include(admin_firm_path(Firm.last.id))
  end

  def when_i_visit_the_email_link
    firms_index_page.load
  end

  def then_i_am_asked_to_sign_in
    expect(sign_in_page).to be_displayed
  end

  def when_i_enter_correct_details
    sign_in_page.login_field.set '123456'
    sign_in_page.password_field.set 'Password1!'
    sign_in_page.submit_button.click
  end

  def then_i_am_on_the_self_service_home_page
    expect(firms_index_page).to be_displayed
  end
end
