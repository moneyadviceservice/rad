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
    form = NewPrincipalForm.new(new_principal_form_params)

    if form.valid?
      create_new_principal(form)
    else
      fail_to_create_new_principal(form)
    end
  end

  private

  def create_new_principal(form)
    user = User.new(form.user_params)
    user.build_principal(form.principal_params)
    user.save!

    Stats.increment('radsignup.principal.created')

    Identification.contact(user.principal).deliver_later
    redirect_to user.principal
  end

  def fail_to_create_new_principal(form)
    @form = form
    flash.now[:error] = t('registration.principal.validation_error_html')
    render 'new'
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
      :confirmed_disclaimer
    )
  end
end
