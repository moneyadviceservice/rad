module SelfService
  class TravelInsuranceOfficesController < ApplicationController
    before_action :authenticate_user!
    before_action -> { @firm = current_firm }
    before_action -> { @office = current_office }, only: %i[edit update destroy]

    def new
      @office = @firm.build_office
    end

    def create
      @office = @firm.build_office(office_params)

      if @office.save_with_geocoding
        flash[:notice] = I18n.t('self_service.office_add.saved')
        redirect_to self_service_travel_insurance_firms_path
      else
        render :new
      end
    end

    def edit; end

    def update
      if @office.update(office_params)
        flash[:notice] = I18n.t('self_service.office_edit.saved')
        redirect_to self_service_travel_insurance_firms_path
      else
        render :edit
      end
    end

    def destroy
      @office.destroy
      flash[:notice] = I18n.t('self_service.office_destroy.deleted',
                              postcode: @office.address_postcode)

      redirect_back(fallback_location: self_service_travel_insurance_firms_path)
    end

    private

    def principal
      current_user.principal
    end

    def current_firm
      TravelInsuranceFirm.find_by(id: params[:travel_insurance_firm_id], fca_number: principal.fca_number)
    end

    def current_office
      @firm.office
    end

    def office_params
      params.require(:office).permit(
        :address_line_one,
        :address_line_two,
        :address_town,
        :address_county,
        :address_postcode,
        :email_address,
        :telephone_number,
        :website,
        :disabled_access
      )
    end
  end
end
