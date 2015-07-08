module SelfService
  class FirmsController < AbstractFirmsController
    def index
      firm = principal.firm
      trading_names = firm.trading_names.registered

      @presenter = FirmsIndexPresenter.new(firm, trading_names, available_trading_names(firm: firm))
    end

    private

    def available_trading_names(firm:)
      registered_trading_names = firm.trading_names.registered
      Lookup::Subsidiary.where(fca_number: firm.fca_number).order('lower(name)').reject do |lookup_name|
        registered_trading_names.map(&:registered_name).include? lookup_name.name
      end
    end
  end
end
