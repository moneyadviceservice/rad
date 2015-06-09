module Dashboard
  class AdvisersController < ApplicationController
    before_action :authenticate_user!

    def index
      @firm = principal.firm
      @trading_names = @firm.trading_names
    end

    def new
      @firm = Firm.find(params[:firm_id])
      @adviser = advisers.build
    end

    private

    def principal
      current_user.principal
    end

    def advisers
      Firm.find_by(id: params[:firm_id], fca_number: principal.fca_number)
          .advisers
    end
  end
end
