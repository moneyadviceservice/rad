class Admin::TravelInsuranceFirmsController < Admin::BaseFirmsController
  def firms_search_path
    admin_travel_insurance_firms_path
  end
  helper_method :firms_search_path

  private

  def resource_class
    TravelInsuranceFirm
  end
end
