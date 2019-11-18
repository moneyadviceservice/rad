class PrincipalsController < ApplicationController
  def pre_qualification_form
    @prequalification = PreQualificationForm.new
  end

  def pre_qualification
    @prequalification = PreQualificationForm.new(
      pre_qualification_form_params
    )

    if @prequalification.valid?
      redirect_to new_principal_path
    else
      redirect_to reject_principals_path
    end
  end

  def rejection_form
    Stats.increment('radsignup.prequalification.rejection')

    @message = ContactForm.new
  end

  def new
    @form = NewPrincipalForm.new
    Stats.increment('radsignup.prequalification.success')
  end

  def show; end

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

  def registration_title
    'registration.heading'
  end
  helper_method :registration_title


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
end
