module Dashboard
  class TradingNamesController < AbstractFirmsController
    def new
      @firm = initialize_firm_from_lookup_trading_name(params[:lookup_id])
    end

    def create
      @firm = initialize_firm_from_lookup_trading_name(params[:lookup_id])
      @firm.assign_attributes(firm_params)
      if @firm.save
        flash[:notice] = I18n.t('dashboard.trading_name_edit.saved')
        render :edit
      else
        render :new
      end
    end

    private

    def initialize_firm_from_lookup_trading_name(id)
      lookup_name = Lookup::Subsidiary.find_by!(id: id, fca_number: principal.fca_number)
      @firm = principal.firm.subsidiaries.find_or_initialize_by(
        registered_name: lookup_name.name,
        fca_number: lookup_name.fca_number
      )
    end
  end
end
