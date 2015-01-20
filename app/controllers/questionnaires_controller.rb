class QuestionnairesController < ApplicationController
  def new
    @lookup_firm = current_user.firm
    @firm = Firm.new
  end

  def create
    @firm = Firm.new(firm_params)

    if @firm.valid?
      render nothing: true
    else
      @lookup_firm = current_user.firm

      render :new
    end
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
        service_region_ids: [],
        in_person_advice_method_ids: [],
        other_advice_method_ids: []
    )
  end
end
