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
    @message = ContactForm.new
  end

  def new
    @principal = Principal.new
  end

  def show
  end

  def create
    @principal = Principal.new(principal_params)

    @principal.save

    redirect_to @principal
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
