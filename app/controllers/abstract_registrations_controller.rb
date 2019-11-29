class AbstractRegistrationsController < ApplicationController
  REGISTRATION_TYPES = %w[
    retirement_advice_registrations
    travel_insurance_registrations
  ].freeze

  before_action :validate_registration_type, only: [:create]

  def new
    @form = NewPrincipalForm.new
    Stats.increment('radsignup.prequalification.success')
  end

  class FirmCopy
    attr_reader :services

    def initialize(form)
      @services = {
        'retirement_advice_registrations' => :firm,
        'travel_insurance_registrations' => :travel_insurance_firm
      }
      @form = form
      @user = User.find_by(email: @form.email)
    end

    def principal_already_registered?
      @user && @user.principal.fca_number.to_s == @form.fca_number
    end

    def can_signup_for_this_service?
      @user.principal.send(services[@form.registration_type]).blank?
    end

    def save
      return false unless principal_already_registered? && can_signup_for_this_service?

      firm = @user.principal.firm || @user.principal.travel_insurance_firm
      firm_attributes = firm.attributes.slice('fca_number', 'registered_name')

      @user.principal.send(
        "create_#{services[@form.registration_type]}", firm_attributes
      )
    end
  end

  def create
    @form = NewPrincipalForm.new(new_principal_form_params)

    return render :show if FirmCopy.new(@form).save

    if @form.valid?
      VerifyReferenceNumberJob.perform_later(registration_data)
      render :show
    else
      flash.now[:error] = t('registration.principal.validation_error_html')
      render :new
    end
  end

  private

  def pre_qualification_form_params
    params.require(:pre_qualification_form).permit(
      :active_question,
      :business_model_question,
      :status_question,
      :particular_market_question,
      :consider_available_providers_question
    )
  end

  def new_principal_form_params
    params.require(:new_principal_form).permit(
      :fca_number,
      :first_name,
      :last_name,
      :job_title,
      :email,
      :telephone_number,
      :password,
      :password_confirmation,
      :confirmed_disclaimer,
      :registration_type
    )
  end

  def registration_data
    required_fields = %w[
      fca_number
      first_name
      last_name
      job_title
      email
      telephone_number
      password
      password_confirmation
      confirmed_disclaimer
      registration_type
    ]
    @form.as_json.slice(*required_fields)
  end

  def validate_registration_type
    redirect_to root_path unless supported_registration_type?
  end

  def supported_registration_type?
    new_principal_form_params[:registration_type].in?(REGISTRATION_TYPES)
  end
end
