class Admin::TravelInsurancePrincipalsController < Admin::PrincipalsController
  layout 'travel_insurance_admin'

  def collection
    Principal.joins(:travel_insurance_firm)
  end

  def collection_path
    admin_travel_insurance_principals_path
  end
  helper_method :collection_path

  def resource_path
    [:admin, :travel_insurance, @principal]
  end
  helper_method :resource_path
end
