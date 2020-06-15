class RetirementAdviceRegistrationsController < BaseRegistrationsController
  def pre_qualification_form
    @prequalification = PreQualificationForm.new
  end

  def pre_qualification
    @prequalification = PreQualificationForm.new(
      pre_qualification_form_params
    )

    if @prequalification.valid?
      redirect_to new_retirement_advice_registration_path
    else
      redirect_to reject_retirement_advice_registrations_path
    end
  end

  def rejection_form
    Stats.increment('radsignup.prequalification.rejection')

    @message = ContactForm.new
  end

  def registration_title
    'retirement_advice_registrations.heading'
  end
  helper_method :registration_title

  def directory_type
    'retirement_advice_registrations'
  end
  helper_method :directory_type

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
end
