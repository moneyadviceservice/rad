class Admin::RetirementPrincipalsController < Admin::PrincipalsController
  def collection
    Principal.joins(:firm).includes(:firm)
  end

  def collection_path
    admin_retirement_principals_path
  end
  helper_method :collection_path

  def resource_path
    [:admin, :retirement, @principal]
  end
  helper_method :resource_path
end
