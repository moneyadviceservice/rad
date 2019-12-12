class Admin::RetirementPrincipalsController < Admin::PrincipalsController
  def collection
    Principal.joins(:firm)
  end

  def collection_path
    admin_retirement_principals_path
  end
  helper_method :collection_path
end
