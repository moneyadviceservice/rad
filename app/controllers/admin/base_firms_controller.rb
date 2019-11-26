class Admin::BaseFirmsController < Admin::ApplicationController
  def index
    @search = resource_class.ransack(params[:q])
    @firms = @search.result.page(params[:page]).per(20)
  end

  def show
    @firm = resource_class.find(params[:id])
  end

  def approve
    firm_id = params[:retirement_firm_id] || params[:travel_insurance_firm_id]
    @firm = resource_class.find(firm_id)
    @firm.approve!
    redirect_back(fallback_location: admin_retirement_firm_path(@firm))
  end

  def firms_search_path
    raise NotImplementedError
  end

  private

  def resource_class
    raise NotImplementedError
  end
end
