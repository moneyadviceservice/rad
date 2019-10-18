module SelfService
  class FirmsController < AbstractFirmsController
    def index
      firm = principal.firm
      trading_names = firm.trading_names.registered

      @presenter = FirmsIndexPresenter.new(
        firm,
        trading_names,
        available_trading_names(firm: firm)
      )
    end

    def edit
      @firm = principal.firm
    end

    def update
      @firm = principal.firm
      if @firm.update(firm_params)
        flash[:notice] = I18n.t('self_service.firm_edit.saved')
        redirect_to_edit
      else
        render :edit
      end
    end

    private

    def available_trading_names(firm:)
      registered_trading_names = firm.trading_names.registered
      Lookup::Subsidiary
        .where(fca_number: firm.fca_number)
        .order('lower(name)')
        .reject do |lookup_name|
          registered_trading_names.map(&:registered_name)
                                  .include? lookup_name.name
        end
    end
  end
end
