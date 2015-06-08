module Dashboard
  class AdvisersController < ApplicationController
    before_action :authenticate_user!

    def index
      @firm = principal.firm
      # @trading_names = @firm.subsidiaries
      @trading_names = [@firm, @firm]
    end

    private

    def principal
      current_user.principal
    end
  end
end
