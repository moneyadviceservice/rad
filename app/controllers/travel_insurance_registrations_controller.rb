class TravelInsuranceRegistrationsController < BaseRegistrationsController
  def registration_title
    'travel_insurance_registrations.heading'
  end
  helper_method :registration_title

  def header_partial
    'shared/travel_header'
  end
  helper_method :header_partial

  def admin_email_address
    ENV['TAD_ADMIN_EMAIL']
  end

  def create
    @form = NewPrincipalForm.new(new_principal_form_params)

    if @form.valid?
      session[:principal] = new_principal_form_params
      redirect_to risk_profile_travel_insurance_registrations_path
    else
      flash.now[:error] = t('registration.principal.validation_error_html')
      render :new
    end
  end

  # Steps
  def risk_profile_form
    @form = TravelInsurance::RiskProfileForm.new
  end

  def risk_profile
    @form = TravelInsurance::RiskProfileForm.new(risk_profile_params)
    session[:risk_profile] = risk_profile_params

    if @form.valid?
      if @form.complete?
        register_and_redirect_user
      elsif @form.reject?
        redirect_to reject_retirement_advice_registrations_path
      else
        redirect_to medical_conditions_travel_insurance_registrations_path
      end
    else
      flash.now[:error] = t('registration.principal.validation_error_html')
      render :risk_profile_form
    end
  end


  private

  def risk_profile_params
    params.require(:travel_insurance_risk_profile_form).permit(
      :covered_by_ombudsman_question, :risk_profile_approach_question
    )
  end
end
