class Admin::PrincipalsController < Admin::ApplicationController
  def index
    @search = Principal.ransack(params[:q])
    @principals = @search.result.page(params[:page]).per(20)
  end

  def show
    @principal = Principal.find(params[:id])
  end
end
