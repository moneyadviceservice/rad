class Admin::FirmsController < Admin::ApplicationController
  def index
    @firms = Firm.page(params[:page]).per(20)
  end

  def show
    @firm = Firm.find(params[:id])
  end
end
