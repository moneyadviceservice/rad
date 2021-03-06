module SelfService
  class TravelInsuranceFirmsController < AbstractTravelInsuranceFirmsController
    def index
      firm = principal.travel_insurance_firm
      trading_names = firm.trading_names

      @presenter = FirmsIndexPresenter.new(
        firm,
        trading_names,
        available_trading_names(firm: firm)
      )
    end

    def edit
      @firm = principal.travel_insurance_firm
      build_travel_firm_associations
    end

    def update
      @firm = principal.travel_insurance_firm

      if @firm.update(firm_params)
        flash[:notice] = I18n.t('self_service.firm_edit.saved')
        redirect_to_edit
      else
        build_travel_firm_associations
        render :edit
      end
    end

    private

    def available_trading_names(firm:)
      registered_trading_names = firm.trading_names
      Lookup::Subsidiary
        .where(fca_number: firm.fca_number)
        .where.not(name: registered_trading_names.map(&:registered_name))
        .order(:name)
    end
  end
end
