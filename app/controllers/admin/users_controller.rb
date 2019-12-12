class Admin::UsersController < Admin::ApplicationController
  layout :check_admin

  def edit
    @user = user
  end

  def update
    @user = user

    if @user.update_attributes(user_params)
      redirect_to principal_resource_path
    else
      render 'edit'
    end
  end

  private

  def user
    User.find_by(principal_token: principal.token)
  end

  def principal
    principal_id =
      params[:retirement_principal_id] || params[:travel_insurance_principal_id]
    Principal.find(principal_id)
  end

  def user_params
    result = params
             .require(:user)
             .permit(:email, :password, :password_confirmation)

    if result[:password].blank? && result[:password_confirmation].blank?
      result.delete(:password)
      result.delete(:password_confirmation)
    end
    result
  end

  def resource_path
    if params[:retirement_principal_id]
      admin_retirement_principal_user_path(@user.principal)
    else
      admin_travel_insurance_principal_user_path(@user.principal)
    end
  end
  helper_method :resource_path

  def principal_resource_path
    if params[:retirement_principal_id]
      admin_retirement_principal_path(principal)
    else
      admin_travel_insurance_principal_path(principal)
    end
  end

  def check_admin
    if params[:retirement_principal_id]
      'admin'
    else
      'travel_insurance_admin'
    end
  end
end
