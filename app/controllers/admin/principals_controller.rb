class Admin::PrincipalsController < Admin::ApplicationController
  def index
    @principals = Principal.page(params[:page]).per(20)
  end

  def show
    @principal = Principal.find(params[:id])
  end
end
