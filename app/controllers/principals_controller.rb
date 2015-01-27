class PrincipalsController < ApplicationController
  skip_before_filter :authenticate

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

    @principal = Principal.new
  end

  def show
  end

  def create
    @principal = Principal.new(principal_params)

    if @principal.save
      Stats.increment('radsignup.principal.created')

      Identification.contact(@principal).deliver_later
      redirect_to @principal
    else
      flash.now[:error] = t('registration.principal.validation_error_html')
      render 'new'
    end
  end

  private

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
