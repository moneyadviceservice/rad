class Admin::UsersController < Admin::ApplicationController
  def switch_user
    user = User.find params[:user_id]
    sign_in(:user, user)
    flash[:notice] = "You are now signed in as #{user.principal.full_name}"
    redirect_to self_service_root_path
  end
end
