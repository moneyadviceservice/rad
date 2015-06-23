module SelfService
  class DashboardController < ApplicationController
    before_action :authenticate_user!

    def index
      @firm = principal.firm
      @firms = principal.main_firm_with_trading_names.registered
      @advisers = Adviser.on_firms_with_fca_number(@firm.fca_number)
      render 'self_service/index'
    end

    private

    def principal
      current_user.principal
    end
  end
end
