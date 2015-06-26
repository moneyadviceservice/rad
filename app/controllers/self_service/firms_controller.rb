module SelfService
  class FirmsController < AbstractFirmsController
    def index
      firm = principal.firm
      trading_names = firm.trading_names.registered
      lookup_names = Lookup::Subsidiary.where(fca_number: firm.fca_number).reject do |lookup_name|
        trading_names.map(&:registered_name).include? lookup_name.name
      end

      @presenter = FirmsIndexPresenter.new(firm, trading_names, lookup_names)
    end
  end
end
