class PrincipalsController < ApplicationController
  def pre_qualification_form
    @prequalification = PreQualificationForm.new
  end

  def pre_qualification
    @prequalification = PreQualificationForm.new(
      params[:pre_qualification_form]
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
      register_new_principal
      render :show
    else
      flash.now[:error] = t('registration.principal.validation_error_html')
      render :new
    end
  end

  private

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
      :confirmed_disclaimer
    )
  end

  def register_new_principal
    VerifiedPrincipal.new(@form).register!
  end
end
