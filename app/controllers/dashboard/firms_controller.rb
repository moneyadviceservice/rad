module Dashboard
  class FirmsController < ApplicationController
    before_action :authenticate_user!

    def index
      @firm = principal.firm
      @trading_names = @firm.subsidiaries
    end

    def edit
      @firm = Firm.find(params[:id])
    end

    def update
      @firm = Firm.find(params[:id])
      @firm.update(firm_params) && flash[:notice] = I18n.t('dashboard.firm_edit.saved')
      render :edit
    end

    private

    def principal
      current_user.principal
    end

    def firm_params
      params.require(:firm).permit(
        :email_address
      )
    end
  end
end
