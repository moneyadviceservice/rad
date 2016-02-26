class Admin::PrincipalsController < Admin::ApplicationController
  def index
    @search = Principal.ransack(params[:q])
    @principals = @search.result.page(params[:page]).per(20)
  end

  def show
    @principal = principal
  end

  def destroy
    user = User.find_by(principal: principal)
    user.principal.destroy
    user.destroy

    redirect_to admin_principals_path
  end

  private

  def principal
    Principal.find(params[:id])
  end

  def principal_params
    params.require(:principal)
  end
end
