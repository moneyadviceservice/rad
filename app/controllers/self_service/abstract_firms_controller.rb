module SelfService
  class AbstractFirmsController < ApplicationController
    before_action :authenticate_user!

    def edit
      @firm = Firm.find(params[:id])
    end

    def update
      @firm = Firm.find(params[:id])
      if @firm.update(firm_params)
        flash[:notice] = I18n.t('self_service.firm_edit.saved')
        redirect_to_edit
      else
        render :edit
      end
    end

    protected

    def principal
      current_user.principal
    end

    FIRM_PARAMS = [
      :email_address,
      :website_address,
      :telephone_number,
      :address_line_one,
      :address_line_two,
      :address_town,
      :address_county,
      :address_postcode,
      :free_initial_meeting,
      :initial_meeting_duration_id,
      :minimum_fixed_fee,
      :retirement_income_products_flag,
      :pension_transfer_flag,
      :long_term_care_flag,
      :equity_release_flag,
      :inheritance_tax_and_estate_planning_flag,
      :wills_and_probate_flag,
      in_person_advice_method_ids: [],
      other_advice_method_ids: [],
      initial_advice_fee_structure_ids: [],
      ongoing_advice_fee_structure_ids: [],
      allowed_payment_method_ids: [],
      investment_size_ids: []
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
