module SelfService
  # rubocop:disable Metrics/ClassLength
  class TravelInsuranceReregistrationsController < AbstractTravelInsuranceFirmsController
    WIZARD_STEPS = %i[risk_profile medical_conditions medical_conditions_questionaire].freeze
    MIN_REQUIRED_POSITIVE_ANSWERS = 12

    before_action :build_reregistration_form, only: %i[new create]

    def registration_title
      'travel_insurance_reregistrations.heading'
    end
    helper_method :registration_title

    def directory_type
      'travel_insurance_registrations'
    end
    helper_method :directory_type

    def admin_email_address
      ENV['TAD_ADMIN_EMAIL']
    end

    def create
      if @form.valid?
        redirect_to risk_profile_self_service_travel_insurance_reregistrations_path
      else
        render :new
      end
    end

    def wizard_form
      clear_any_future_questions
      form_name = "#{current_step}_form"
      @form = "TravelInsurance::#{form_name.camelize}".constantize.new
      render form_name
    end

    def wizard
      form_name = "#{current_step}_form"
      form_params = send("#{current_step}_form_params")

      @form = "TravelInsurance::#{form_name.camelize}".constantize.new(form_params)
      session[current_step.to_sym] = form_params

      if @form.valid?
        if completed_registration?
          reregister_and_redirect_user
        elsif rejected_registration?
          redirect_to reject_self_service_travel_insurance_reregistrations_path
        else
          redirect_to next_url
        end
      else
        render form_name.to_sym
      end
    end

    def rejection_form
      Stats.increment('tadsignup.prequalification.rejection')

      principal_details = current_user.principal.attributes.slice(
        :fca_number,
        :first_name,
        :last_name,
        :email
      )

      Admin::FirmMailer.rejected_firm(principal_details).deliver_later if principal_details.present?
      session.clear
    end

    private

    def build_reregistration_form
      @form = TravelInsurance::ReregistrationForm.new(
        current_user.principal.travel_insurance_firm,
        reregistration_form_params
      )
    end

    def rejected_registration?
      case current_step.to_sym
      when :risk_profile
        risk_profile_form_params[:covered_by_ombudsman_question] == 'false' ||
          risk_profile_form_params[:risk_profile_approach_question] == 'neither' ||
          risk_profile_form_params[:supplies_documentation_when_needed_question] == 'false'
      when :medical_conditions_questionaire
        !medical_questionaire_acceptable?
      else
        false
      end
    end

    def completed_registration?
      case current_step.to_sym
      when :medical_conditions
        medical_conditions_form_params[:covers_medical_condition_question] == 'one_specific'
      when :medical_conditions_questionaire
        medical_questionaire_acceptable?
      else
        false
      end
    end

    def reregistration_form_params
      params.fetch(:travel_insurance_reregistration_form, {}).permit(:confirmed_disclaimer)
    end

    def risk_profile_form_params
      params.fetch(:travel_insurance_risk_profile_form, {}).permit(
        :covered_by_ombudsman_question,
        :risk_profile_approach_question,
        :supplies_documentation_when_needed_question
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
        :lupus_question, :sickle_cell_and_renal_question, :sub_arachnoid_haemorrhage_and_epilepsy_question,
        :prostate_cancer_question, :type_one_diabetes_question, :parkinsons_disease_question, :hiv_question
      )
    end

    def medical_questionaire_acceptable?
      positive_answers_count = medical_conditions_questionaire_form_params.values.select { |i| i == 'true' }.count
      positive_answers_count >= MIN_REQUIRED_POSITIVE_ANSWERS
    end

    def all_registration_answers
      registration_answers = {}
      WIZARD_STEPS.each do |step|
        registration_answers.merge!(session[step.to_sym]) unless session[step.to_sym].nil?
      end
      registration_answers
    end

    def reregister_and_redirect_user
      firm = current_user.principal.travel_insurance_firm
      firm.update!(
        all_registration_answers.merge(
          reregistered_at: Time.zone.now,
          confirmed_disclaimer: true
        )
      )

      Admin::FirmMailer.reregistered_firm(firm).deliver_later

      flash[:success] = t('travel_insurance_reregistrations.success_message')
      redirect_to self_service_root_path
    end

    def next_url
      current_step_index = WIZARD_STEPS.index(current_step.to_sym)
      if (next_step = WIZARD_STEPS[current_step_index + 1])
        send("#{next_step}_self_service_travel_insurance_reregistrations_path")
      else
        root_path
      end
    end

    def clear_any_future_questions
      WIZARD_STEPS.drop(WIZARD_STEPS.find_index(current_step.to_sym) + 1).each do |next_step|
        session[next_step] = nil
      end
    end

    def current_step
      raise unless WIZARD_STEPS.include?(params[:current_step].to_sym)

      params[:current_step]
    end
  end
  # rubocop:enable Metrics/ClassLength
end
