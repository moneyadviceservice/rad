class AdvisersController < PrincipalsBaseController
  def new
    @adviser = advisers.build
  end

  def create
    @adviser = advisers.create(adviser_params)

    if @adviser.valid?
      stat
      redirect_to principal_firm_adviser_path(id: @adviser)
    else
      render :new
    end
  end

  def show
    @adviser = advisers.find(params[:id])
  end

  private

  def stat
    'radsignup.adviser.registered'.tap do |key|
      Stats.increment(key)
      Stats.gauge(key, Adviser.count)
    end
  end

  def advisers
    Firm
      .find_by(id: params[:firm_id], fca_number: current_principle.fca_number)
      .advisers
  end

  def adviser_params
    params.require(:adviser)
      .permit(
        :reference_number,
        :travel_distance,
        :postcode,
        :covers_whole_of_uk,
        qualification_ids: [],
        accreditation_ids: [],
        professional_standing_ids: [],
        professional_body_ids: []
      )
  end
end
