module Dashboard
  class DashboardController < ApplicationController
    before_action :authenticate_user!

    def index
      @firm = principal.firm
      @trading_names = @firm.subsidiaries
      @advisers = Adviser.on_firms_with_fca_number(@firm.fca_number)
      render 'dashboard/index'
    end

    private

    def principal
      current_user.principal
    end
  end
end
