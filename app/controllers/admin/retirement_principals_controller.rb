class Admin::RetirementPrincipalsController < Admin::PrincipalsController
  def collection
    Principal.joins(:firm)
  end
end
