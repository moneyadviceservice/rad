class Admin::PrincipalsController < Admin::ApplicationController
  def index
    @search = Principal.ransack(params[:q])
    @principals = @search.result.page(params[:page]).per(20)
  end

  def show
    @principal = principal
  end

  def edit
    @principal = principal
  end

  def update
    @principal = principal

    if @principal.update_attributes(principal_params)
      redirect_to admin_principal_path(@principal)
    else
      render 'edit'
    end
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
    params.require(:principal).permit(:first_name,
                                      :last_name,
                                      :fca_number,
                                      :job_title,
                                      :email_address,
                                      :telephone_number,
                                      :confirmed_disclaimer)
  end
end
