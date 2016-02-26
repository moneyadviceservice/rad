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

    message = "Successfully deleted #{principal.full_name}, " \
              "#{principal.firm.registered_name} and " \
              "#{principal.firm.trading_names.count} related trading names."

    user.principal.destroy
    user.destroy

    redirect_to admin_principals_path, notice: message
  end

  private

  def principal
    Principal.find(params[:id])
  end

  def principal_params
    params.require(:principal)
  end
end
