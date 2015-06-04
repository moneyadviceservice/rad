module Dashboard
  class FirmsController < AbstractFirmsController
    def index
      @firm = principal.firm
      @trading_names = @firm.trading_names.registered
      @lookup_names = Lookup::Subsidiary.where(fca_number: @firm.fca_number).reject do |lookup_name|
        @trading_names.map(&:registered_name).include? lookup_name.name
      end
    end
  end
end
