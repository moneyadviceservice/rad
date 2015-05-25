module Dashboard
  class FirmsController < ApplicationController
    before_action :authenticate_user!

    def index
      @firm = principal.firm
      @trading_names = @firm.subsidiaries
    end

    private

    def principal
      current_user.principal
    end
  end
end
