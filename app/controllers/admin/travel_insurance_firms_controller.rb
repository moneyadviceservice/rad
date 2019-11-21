class Admin::TravelInsuranceFirmsController < Admin::FirmsController
  def index
    @search = TravelInsuranceFirm.ransack(params[:q])
    @firms = @search.result.page(params[:page]).per(20)
  end

  def show
    @firm = TravelInsuranceFirm.find(params[:id])
  end
end
