class Admin::TravelInsuranceFirmsController < Admin::BaseFirmsController
  layout 'travel_insurance_admin'

  def reregister_approve
    @firm = TravelInsuranceFirm.find(params[:travel_insurance_firm_id])
    @firm.reregister_approve!

    redirect_back(fallback_location: admin_retirement_firm_path(@firm))
  end

  def firms_search_path
    admin_travel_insurance_firms_path
  end
  helper_method :firms_search_path

  def approval_path
    admin_travel_insurance_firm_approve_path(@firm.id)
  end
  helper_method :approval_path

  def hide_path
    admin_travel_insurance_firm_hide_path(@firm.id)
  end
  helper_method :hide_path

  def resource_path
    admin_travel_insurance_principal_path(@firm.principal)
  end

  private

  def resource_class
    TravelInsuranceFirm.includes(:principal)
  end
end
