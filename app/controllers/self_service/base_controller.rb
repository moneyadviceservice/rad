module SelfService
  class BaseController < ApplicationController
    before_action :authenticate_user!

    def choose_firm_type
      if current_user.principal.firm
        redirect_to self_service_firms_path
      else
        redirect_to self_service_travel_insurance_firms_path
      end
    end
  end
end
