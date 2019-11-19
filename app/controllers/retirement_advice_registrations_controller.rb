class RetirementAdviceRegistrationsController < AbstractRegistrationsController
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
end
