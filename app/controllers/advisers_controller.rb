class AdvisersController < ApplicationController
  def new
    @adviser = advisers.build
  end

  def create
    @adviser = advisers.create(adviser_params)

    if @adviser.valid?
      redirect_to principal_firm_adviser_path(id: @adviser)
    else
      render :new
    end
  end

  def show
    @adviser = advisers.find(params[:id])
  end

  private

  def advisers
    current_user.firm.advisers
  end

  def adviser_params
    params.require(:adviser)
      .permit(
        :reference_number,
        :confirmed_disclaimer,
        qualification_ids: [],
        accreditation_ids: [],
        professional_standing_ids: [],
        professional_body_ids: []
      )
      .merge(
        name: 'Temporary Name'
      )
  end
end
