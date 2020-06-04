module SelfService
  class AbstractTravelInsuranceFirmsController < ApplicationController
    before_action :authenticate_user!

    protected

    def principal
      current_user.principal
    end

    FIRM_PARAMS = [
      :website_address,
      :covered_by_ombudsman_question,
      :risk_profile_approach_question
    ].freeze

    def firm_params
      params.require(:travel_insurance_firm).permit(*FIRM_PARAMS)
    end

    def redirect_to_edit(firm_id: params[:firm_id])
      redirect_to(
        controller: params[:controller],
        action: :edit,
        firm_id: firm_id
      )
    end
  end
end
