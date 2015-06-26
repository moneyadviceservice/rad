module SelfService
  class FirmsController < AbstractFirmsController
    def index
      @firm = principal.firm
      @trading_names = @firm.trading_names.registered
      @lookup_names = Lookup::Subsidiary.where(fca_number: @firm.fca_number).reject do |lookup_name|
        @trading_names.map(&:registered_name).include? lookup_name.name
      end
    end

    def destroy
      trading_name = principal.firm.trading_names.registered.find(params[:id])
      trading_name.destroy
      flash[:notice] = I18n.t('self_service.firm_destroy.deleted', name: trading_name.registered_name)

      redirect_to :back
    end
  end
end
