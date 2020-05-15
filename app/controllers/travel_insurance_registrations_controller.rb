class TravelInsuranceRegistrationsController < BaseRegistrationsController
  WIZARD_STEPS = [:risk_profile, :medical_conditions, :medical_conditions_questionaire].freeze

  def registration_title
    'travel_insurance_registrations.heading'
  end
  helper_method :registration_title

  def header_partial
    'shared/travel_header'
  end
  helper_method :header_partial

  def directory_type
    'travel_insurance_registrations'
  end
  helper_method :directory_type

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
    if session[:principal].blank?
      redirect_to new_travel_insurance_registration_path
    else
      clear_any_future_questions
      form_name = "#{params[:current_step]}_form"
      @form = "TravelInsurance::#{form_name.camelize}".constantize.new
      render form_name
    end
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
        redirect_to reject_travel_insurance_registrations_path
      else
        redirect_to next_url
      end
    else
      flash.now[:error] = t('registration.principal.validation_error_html')
      render form_name.to_sym
    end
  end

  def rejection_form
    Stats.increment('tadsignup.prequalification.rejection')

    principal_details = ActiveSupport::HashWithIndifferentAccess.new(session[:principal]).slice(
      :fca_number,
      :first_name,
      :last_name,
      :email
    )

    Admin::FirmMailer.rejected_firm(principal_details).deliver_later if principal_details.present?
    session.clear
  end

  private

  def rejected_registration?
    case params[:current_step].to_sym
    when :risk_profile
      risk_profile_form_params[:covered_by_ombudsman_question] == '0' || risk_profile_form_params[:risk_profile_approach_question] == 'neither'
    when :medical_conditions_questionaire
      !medical_questionaire_acceptable?
    else
      false
    end
  end

  def completed_registration?
    case params[:current_step].to_sym
    when :risk_profile
      risk_profile_form_params[:covered_by_ombudsman_question] == '1' && risk_profile_form_params[:risk_profile_approach_question] == 'bespoke'
    when :medical_conditions
      medical_conditions_form_params[:covers_medical_condition_question] == 'one_specific'
    when :medical_conditions_questionaire
      medical_questionaire_acceptable?
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

  def medical_conditions_questionaire_form_params
    params.fetch(:travel_insurance_medical_conditions_questionaire_form, {}).permit(
      :metastatic_breast_cancer_question, :ulceritive_colitis_and_anaemia_question,
      :heart_attack_with_hbp_and_high_cholesterol_question, :copd_with_respiratory_infection_question,
      :motor_neurone_disease_question, :hodgkin_lymphoma_question,
      :acute_myeloid_leukaemia_question, :guillain_barre_syndrome_question,
      :heart_failure_and_arrhytmia_question, :stroke_with_hbp_question,
      :peripheral_vascular_disease_question, :schizophrenia_question,
      :lupus_question, :sickle_cell_and_renal_question, :sub_arachnoid_haemorrhage_and_epilepsy_question
    )
  end

  def medical_questionaire_acceptable?
    positive_answers_count = medical_conditions_questionaire_form_params.values.select { |i| i == '1' }.count
    positive_answers_count >= (medical_conditions_questionaire_form_params.values.count * 0.5).ceil
  end

  def register_and_redirect_user
    submitted_data = NewPrincipalForm.new(session[:principal])
    DirectoryRegistrationService.call(submitted_data)
    session.clear
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

  def clear_any_future_questions
    WIZARD_STEPS.drop(WIZARD_STEPS.find_index(params[:current_step].to_sym) + 1).each do |next_step|
      session[next_step] = nil
    end
  end
end
