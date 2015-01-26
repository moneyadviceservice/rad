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
    Firm
      .find_by(id: params[:firm_id], fca_number: current_user.fca_number)
      .advisers
  end

  def adviser_params
    params.require(:adviser)
      .permit(
        :reference_number,
        :travel_distance,
        :postcode,
        :covers_whole_of_uk,
        :confirmed_disclaimer,
        qualification_ids: [],
        accreditation_ids: [],
        professional_standing_ids: [],
        professional_body_ids: []
      )
  end
end
