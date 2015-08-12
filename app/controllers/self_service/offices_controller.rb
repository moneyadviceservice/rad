module SelfService
  class OfficesController < ApplicationController
    before_action :authenticate_user!
    before_action -> { @firm = current_firm }

    private

    def principal
      current_user.principal
    end

    def current_firm
      Firm.find_by(id: params[:firm_id], fca_number: principal.fca_number)
    end
  end
end
