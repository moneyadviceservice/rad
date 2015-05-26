class PrincipalsController < ApplicationController
  def pre_qualification_form
    @prequalification = PreQualificationForm.new
  end

  def pre_qualification
    @prequalification = PreQualificationForm.new(params[:pre_qualification_form])

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
    Stats.increment('radsignup.prequalification.success')
    @user = User.new
    @principal = @user.build_principal
  end

  def show
  end

  def create
    @user = User.new(user_params)
    @principal = @user.build_principal(principal_params.merge(email_address: user_params[:email]))

    if @user.save
      Stats.increment('radsignup.principal.created')

      Identification.contact(@principal).deliver_later
      redirect_to @principal
    else
      flash.now[:error] = t('registration.principal.validation_error_html')
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit!
  end

  def principal_params
    params.require(:principal)
      .permit(
        :fca_number,
        :website_address,
        :first_name,
        :last_name,
        :job_title,
        :email_address,
        :telephone_number,
        :confirmed_disclaimer
      )
  end
end
