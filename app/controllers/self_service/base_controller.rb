module SelfService
  class BaseController < ApplicationController
    before_action :authenticate_user!

    def choose_firm_type
      redirect_to self_service_travel_insurance_firms_path
    end
  end
end
