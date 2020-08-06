module SelfService
  class TravelInsuranceTradingNamesController < AbstractTravelInsuranceFirmsController
    def new
      @firm = initialize_firm_from_lookup_trading_name(params[:lookup_id])
      build_travel_firm_associations
    end

    def create
      @firm = build_firm_from_lookup_trading_name

      if @firm.save
        flash[:notice] = I18n.t('self_service.trading_name_edit.saved')
        redirect_to edit_self_service_travel_insurance_trading_name_path(@firm)
      else
        build_travel_firm_associations
        render :new
      end
    end

    def edit
      @firm = current_firm.trading_names.find(params[:id])
      build_travel_firm_associations
    end

    def update
      @firm = current_firm.trading_names.find(params[:id])
      build_travel_firm_associations
      if @firm.update(firm_params)
        flash[:notice] = I18n.t('self_service.firm_edit.saved')
        redirect_to_edit
      else
        render :edit
      end
    end

    def destroy
      trading_name = current_firm.trading_names.find(params[:id])
      trading_name.destroy
      flash[:notice] = I18n.t('self_service.trading_name_destroy.deleted',
                              name: trading_name.registered_name)

      redirect_back(fallback_location: self_service_firms_path)
    end

    private

    def build_firm_from_lookup_trading_name
      initialize_firm_from_lookup_trading_name(params[:lookup_id]).tap do |firm|
        firm.assign_attributes(firm_params)
      end
    end

    def initialize_firm_from_lookup_trading_name(id)
      lookup_name = Lookup::Subsidiary
                    .find_by!(id: id, fca_number: principal.fca_number)

      @firm = current_firm.trading_names.find_or_initialize_by(
        registered_name: lookup_name.name,
        fca_number: lookup_name.fca_number
      )
    end

    def current_firm
      principal.travel_insurance_firm
    end
  end
end
