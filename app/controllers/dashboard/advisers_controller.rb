module Dashboard
  class AdvisersController < ApplicationController
    before_action :authenticate_user!

    def index
      @firm = principal.firm
      @trading_names = @firm.trading_names
    end

    private

    def principal
      current_user.principal
    end
  end
end
