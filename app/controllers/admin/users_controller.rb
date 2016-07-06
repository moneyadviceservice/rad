class Admin::UsersController < Admin::ApplicationController
  def edit
    @user = user
  end

  def update
    @user = user

    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update_attributes(user_params)
      redirect_to admin_principal_path(principal)
    else
      render 'edit'
    end
  end

  def switch_user
    user = User.find params[:user_id]
    sign_in(:user, user)
    flash[:notice] = "You are now signed in as #{user.principal.full_name}"
    redirect_to self_service_root_path
  end

  private

  def user
    User.find_by(principal_token: principal.token)
  end

  def principal
    Principal.find(params[:principal_id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
