class QuestionnairesController < PrincipalsBaseController
  def edit
    @firm = firm_or_subsidiary
  end

  def update
    @firm = firm_or_subsidiary

    if @firm.update(firm_params)
      stat
      redirect_to new_principal_firm_adviser_path(current_principle, @firm)
    else
      render :edit
    end
  end

  private

  def stat
    'radsignup.firm.registered'.tap do |key|
      Stats.increment(key)
      Stats.gauge(key, Firm.registered.count)
    end
  end

  def firm_or_subsidiary
    Firm.find_by(id: params[:firm_id], fca_number: current_principle.fca_number)
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
    :other_flag,
    in_person_advice_method_ids: [],
    other_advice_method_ids: [],
    initial_advice_fee_structure_ids: [],
    ongoing_advice_fee_structure_ids: [],
    allowed_payment_method_ids: [],
    investment_size_ids: []
  ]

  def firm_params
    params.require(:firm).permit(*FIRM_PARAMS)
  end
end
