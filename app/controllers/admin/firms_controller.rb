class Admin::FirmsController < Admin::ApplicationController
  def index
    @search = Firm.ransack(params[:q])
    @firms = @search.result.page(params[:page]).per(20)
  end

  def show
    @firm = Firm.find(params[:id])
  end
end
