class TravelInsuranceRegistrationsController < BaseRegistrationsController
  WIZARD_STEPS = [:risk_profile, :medical_conditions].freeze

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

  def wizard_form
    form_name = "#{params[:current_step]}_form"
    @form = "TravelInsurance::#{form_name.camelize}".constantize.new
    render form_name
  end

  def wizard
    form_name = "#{params[:current_step]}_form"
    form_params = send("#{params[:current_step]}_form_params")

    @form = "TravelInsurance::#{form_name.camelize}".constantize.new(form_params)
    session[params[:current_step].to_sym] = form_params

    if @form.valid?
      if completed_registration?
        register_and_redirect_user
      elsif rejected_registration?
        redirect_to reject_retirement_advice_registrations_path
      else
        redirect_to next_url
      end
    else
      flash.now[:error] = t('registration.principal.validation_error_html')
      render form_name.to_sym
    end
  end

  private

  def rejected_registration?
    if params[:current_step].to_sym == :risk_profile
      risk_profile_form_params[:covered_by_ombudsman_question] == 'false' || risk_profile_form_params[:risk_profile_approach_question] == 'neither'
    else
      false
    end
  end

  def completed_registration?
    case params[:current_step].to_sym
    when :risk_profile
      risk_profile_form_params[:covered_by_ombudsman_question] == 'true' && risk_profile_form_params[:risk_profile_approach_question] == 'bespoke'
    when :medical_conditions
      medical_conditions_form_params[:covers_medical_condition_question] == 'one_specific'
    else
      false
    end
  end

  def risk_profile_form_params
    params.fetch(:travel_insurance_risk_profile_form, {}).permit(
      :covered_by_ombudsman_question, :risk_profile_approach_question
    )
  end

  def medical_conditions_form_params
    params.fetch(:travel_insurance_medical_conditions_form, {}).permit(
      :covers_medical_condition_question
    )
  end

  def all_registration_answers
    registration_answers = {}
    WIZARD_STEPS.each do |step|
      registration_answers.merge!(send("#{step}_form_params"))
    end
    registration_answers
  end

  def register_and_redirect_user
    submitted_data = NewPrincipalForm.new(session[:principal])
    TravelInsuranceFirm.cache_question_answers(all_registration_answers.merge(fca_number: submitted_data.fca_number, email: submitted_data.email_address))
    DirectoryRegistrationService.call(submitted_data)
    render :show
  end

  def next_url
    current_step_index = WIZARD_STEPS.index(params[:current_step].to_sym)
    if (next_step = WIZARD_STEPS[current_step_index + 1])
      send("#{next_step}_travel_insurance_registrations_path")
    else
      root_path
    end
  end
end
