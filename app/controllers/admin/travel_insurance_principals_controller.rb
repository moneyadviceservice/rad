class Admin::TravelInsurancePrincipalsController < Admin::PrincipalsController
  layout 'travel_insurance_admin'

  def collection
    Principal.joins(:travel_insurance_firm)
  end
end
