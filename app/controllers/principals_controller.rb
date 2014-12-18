class PrincipalsController < ApplicationController
  def pre_qualification_form
    @prequalification = PreQualificationForm.new
  end

  def pre_qualification
    @prequalification = PreQualificationForm.new(params[:pre_qualification_form])

    if @prequalification.valid?
      redirect_to identify_principal_path
    else
      flash[:error] = 'Must answer yes'
      render :pre_qualification_form, status: :bad_request
    end
  end

  def identification_form
  end

  def rejection_form
  end
end
