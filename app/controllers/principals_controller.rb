class PrincipalsController < ApplicationController
  def pre_qualification_form
    @prequalification = PreQualificationForm.new
  end

  def pre_qualification
    @prequalification = PreQualificationForm.new(params[:pre_qualification_form])

    if @prequalification.valid?
      redirect_to identify_principal_path
    else
      redirect_to reject_principal_path
    end
  end

  def rejection_form
    @message = ContactForm.new
  end

  def identification_form
    @principal = Principal.new
  end

  def create
    head :created
  end
end
