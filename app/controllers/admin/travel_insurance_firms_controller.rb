class Admin::TravelInsuranceFirmsController < Admin::BaseFirmsController
  layout 'travel_insurance_admin'

  def firms_search_path
    admin_travel_insurance_firms_path
  end
  helper_method :firms_search_path

  def approval_path
    admin_travel_insurance_firm_approve_path(@firm.id)
  end
  helper_method :approval_path

  private

  def resource_class
    TravelInsuranceFirm
  end
end
