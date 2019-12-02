RSpec.feature 'Principal provides travel insurance information', :inline_job_queue do
  let(:travel_insurance_registration_page) do
    TravelInsuranceRegistrationPage.new
  end
  let(:thank_you_for_registering_page) do
    TravelInsuranceRegistrationThankYouPage.new
  end
  let(:sign_in_page) { SignInPage.new }

  before { ActionMailer::Base.deliveries.clear }

  scenario 'Registering a travel insurance firm' do
    given_i_am_on_the_travel_insurance_registration_page
    when_i_provide_my_firms_fca_reference_number
    and_i_provide_my_identifying_particulars
    then_i_am_shown_a_thank_you_for_registering_message
    and_i_should_have_a_travel_insurance_firm
    and_i_later_receive_an_email_confirming_my_registration
  end

  scenario 'Re-registering the same travel insurance firm' do
    given_i_am_on_the_travel_insurance_registration_page
    and_i_registered_a_principal_and_travel_insurance_firm
    when_i_provide_my_firms_fca_reference_number
    and_i_provide_my_identifying_particulars
    then_i_am_told_which_fields_are_incorrect_and_why
  end

  scenario 'Registering a travel insurance firm having a retirement firm' do
    given_i_am_on_the_travel_insurance_registration_page
    and_i_registered_a_principal_and_retirement_advice_firm
    when_i_provide_my_firms_fca_reference_number
    and_i_provide_my_identifying_particulars
    then_i_am_shown_a_thank_you_for_registering_message
    and_i_should_have_a_retirement_and_travel_insurance_firm
    and_i_later_receive_an_email_confirming_my_registration
  end

  def given_i_am_on_the_travel_insurance_registration_page
    travel_insurance_registration_page.load
  end

  def when_i_provide_my_firms_fca_reference_number
    travel_insurance_registration_page.reference_number.set '311244'
  end

  def and_i_provide_my_identifying_particulars
    travel_insurance_registration_page.tap do |p|
      p.first_name.set principal_details.first_name
      p.last_name.set principal_details.last_name
      p.job_title.set principal_details.job_title
      p.email.set principal_details.email_address
      p.password.set 'Password1!'
      p.password_confirmation.set 'Password1!'
      p.telephone_number.set principal_details.telephone_number

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

  def and_i_registered_a_principal_and_retirement_advice_firm
    principal = create_principal
    expect(principal.firm).to_not be_nil
    expect(principal.travel_insurance_firm).to be_nil
  end

  def and_i_registered_a_principal_and_travel_insurance_firm
    principal = create_principal(
      manually_build_firms: true,
      travel_insurance_firm: FactoryBot.create(
        :travel_insurance_firm,
        fca_number: '311244'
      )
    )

    expect(principal.firm).to be_nil
    expect(principal.travel_insurance_firm).to_not be_nil
  end

  def then_i_am_shown_a_thank_you_for_registering_message
    expect(thank_you_for_registering_page).to have_content(
      I18n.t('success.heading')
    )
    expect(thank_you_for_registering_page).to have_content(
      I18n.t('success.message')
    )
  end

  def and_i_should_have_a_travel_insurance_firm
    principal = Principal.find_by(fca_number: '311244')
    expect(principal.travel_insurance_firm).to_not be_nil
  end

  def and_i_should_have_a_retirement_and_travel_insurance_firm
    principal = Principal.find_by(fca_number: '311244')
    expect(principal.firm).to_not be_nil
    expect(principal.travel_insurance_firm).to_not be_nil
  end

  def then_i_am_told_which_fields_are_incorrect_and_why
    expect(travel_insurance_registration_page).to have_validation_summaries
  end

  private

  def create_principal(attributes = {})
    principal = FactoryBot.create(
      :principal,
      { fca_number: '311244' }.merge(attributes).merge(principal_details.to_h)
    )
    FactoryBot.create(
      :user,
      email: principal_details.email_address,
      principal: principal
    )
    principal
  end

  def principal_details
    OpenStruct.new(
      first_name: 'Ben',
      last_name: 'Lovell',
      job_title: 'Director',
      email_address: 'ben@moneyadviceservice.org.uk',
      telephone_number: '07715 930 400'
    )
  end
end
