class Admin::PrincipalsController < Admin::ApplicationController
  def index
    @search = Principal.ransack(params[:q])
    @principals = @search.result.page(params[:page]).per(20)
  end

  def show
    @principal = principal
    @user = User.find_by(principal_token: principal.token)
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

    message = destroy_message(principal)

    ActiveRecord::Base.transaction do
      user.principal.destroy!
      user.destroy!
    end

    redirect_to admin_principals_path, notice: message
  end

  def verify_fca_number
    @principal = Principal.find(params[:principal_id])
    @principal.verify_fca!
    @firm = @principal.firm

    redirect_to admin_firm_path(@firm.id)
  end

  private

  def principal
    Principal.find(params[:id])
  end

  def destroy_message(principal)
    "Successfully deleted #{principal.full_name}, " \
    "#{principal.firm.registered_name} and " \
    "#{principal.firm.trading_names.count} related trading names."
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
