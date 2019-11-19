class AbstractRegistrationsController < ApplicationController
  REGISTRATION_TYPES = %w[retirement_advice_registrations travel_insurance_registrations].freeze

  before_action :validate_registration_type, only: [:create]

  def new
    @form = NewPrincipalForm.new
    Stats.increment('radsignup.prequalification.success')
  end

  def create
    @form = NewPrincipalForm.new(new_principal_form_params)

    if @form.valid?
      VerifyReferenceNumberJob.perform_later(principal_form_data)
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

  def principal_form_data
    @form.as_json.slice(
      'fca_number',
      'first_name',
      'last_name',
      'job_title',
      'email',
      'telephone_number',
      'password',
      'password_confirmation',
      'confirmed_disclaimer',
      'registration_type'
    )
  end

  def validate_registration_type
    redirect_to root_path unless new_principal_form_params[:registration_type].in?(REGISTRATION_TYPES)
  end
end
