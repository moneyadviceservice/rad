class Admin::Lookup::FirmsController < Admin::ApplicationController
  def index
    @search = ::Lookup::Firm.ransack(params[:q])
    @firms = @search.result.page(params[:page]).per(20)
  end
end
