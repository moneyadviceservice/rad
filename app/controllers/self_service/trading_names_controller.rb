module SelfService
  class TradingNamesController < AbstractFirmsController
    def new
      @firm = initialize_firm_from_lookup_trading_name(params[:lookup_id])
    end

    def create
      @firm = build_firm_from_lookup_trading_name
      if @firm.save
        flash[:notice] = I18n.t('self_service.trading_name_edit.saved')
        redirect_to edit_self_service_trading_name_path(@firm)
      else
        render :new
      end
    end

    def edit
      @firm = principal.firm.trading_names.find(params[:id])
    end

    def update
      @firm = principal.firm.trading_names.find(params[:id])
      if @firm.update(firm_params)
        flash[:notice] = I18n.t('self_service.firm_edit.saved')
        redirect_to_edit
      else
        render :edit
      end
    end

    def destroy
      trading_name = principal.firm.trading_names.onboarded.find(params[:id])
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
      @firm = principal.firm.trading_names.find_or_initialize_by(
        registered_name: lookup_name.name,
        fca_number: lookup_name.fca_number
      )
    end
  end
end
