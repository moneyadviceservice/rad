class Admin::UsersController < Admin::ApplicationController
  def edit
    @user = user
  end

  def update
    @user = user

    if @user.update_attributes(user_params)
      redirect_to admin_principal_path(principal)
    else
      render 'edit'
    end
  end

  private

  def user
    User.find_by(principal_token: principal.token)
  end

  def principal
    Principal.find(params[:principal_id])
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
end
