module SelfService
  class AbstractFirmsController < ApplicationController
    before_action :authenticate_user!

    protected

    def principal
      current_user.principal
    end

    FIRM_PARAMS = [
      :email_address,
      :website_address,
      :telephone_number,
      :free_initial_meeting,
      :initial_meeting_duration_id,
      :minimum_fixed_fee,
      :retirement_income_products_flag,
      :pension_transfer_flag,
      :long_term_care_flag,
      :equity_release_flag,
      :inheritance_tax_and_estate_planning_flag,
      :wills_and_probate_flag,
      :primary_advice_method,
      :ethical_investing_flag,
      :sharia_investing_flag,
      :workplace_financial_advice_flag,
      :status,
      in_person_advice_method_ids: [],
      other_advice_method_ids: [],
      initial_advice_fee_structure_ids: [],
      ongoing_advice_fee_structure_ids: [],
      allowed_payment_method_ids: [],
      investment_size_ids: [],
      languages: []
    ].freeze

    def firm_params
      params.require(:firm).permit(*FIRM_PARAMS)
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
