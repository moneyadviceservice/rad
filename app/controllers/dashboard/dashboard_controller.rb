module Dashboard
  class DashboardController < ApplicationController
    before_action :authenticate_user!

    def index
      @firms = all_firms_associated_with_principal
      render 'dashboard/index'
    end

    private

    def principal
      current_user.principal
    end

    def all_firms_associated_with_principal
      [principal.firm].concat(principal.firm.subsidiaries)
    end
  end
end
