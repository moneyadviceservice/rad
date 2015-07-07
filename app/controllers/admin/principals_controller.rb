class Admin::PrincipalsController < Admin::ApplicationController
  def index
    @search = Principal.ransack(params[:q])
    @principals = @search.result.page(params[:page]).per(20)
  end

  def show
    @principal = principal
  end

  private

  def principal
    Principal.find(params[:id])
  end

  def principal_params
    params.require(:principal)
  end
end
