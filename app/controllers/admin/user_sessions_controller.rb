class Admin::UserSessionsController < Admin::ApplicationController
  def create
    sign_in(:user, user)
    flash[:notice] = "You are now signed in as #{user.principal.full_name}"
    redirect_to self_service_root_path
  end

  private

  def user
    User.find(params[:user_id])
  end
end
