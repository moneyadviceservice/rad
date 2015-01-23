class QuestionnairesController < ApplicationController
  def show
    @firm = current_user.firm
  end

  def update
    @firm = current_user.firm
    @firm.update!(firm_params)
    redirect_to(new_principal_firm_adviser_path, principal: current_user)
  rescue ActiveRecord::ActiveRecordError
    render :show
  end

  private

  def firm_params
    params.require(:firm)
    .permit(
        :email_address,
        :telephone_number,
        :address_line_1,
        :address_line_2,
        :address_town,
        :address_county,
        :address_postcode,
        :free_initial_meeting,
        :initial_meeting_duration_id,
        :minimum_fixed_fee,
        :retirement_income_products_percent,
        :pension_transfer_percent,
        :long_term_care_percent,
        :equity_release_percent,
        :inheritance_tax_and_estate_planning_percent,
        :wills_and_probate_percent,
        :other_percent,
        in_person_advice_method_ids: [],
        other_advice_method_ids: [],
        initial_advice_fee_structure_ids: [],
        ongoing_advice_fee_structure_ids: [],
        allowed_payment_method_ids: [],
        investment_size_ids: []
    )
  end
end
