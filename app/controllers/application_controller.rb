class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate

  def display_search_box_in_header?
    false
  end

  helper_method :display_search_box_in_header?

  def display_auth_in_header?
    false
  end

  helper_method :display_auth_in_header?

  def display_adviser_sign_in?
    false
  end

  helper_method :display_adviser_sign_in?

  helper_method :current_user

  private

  def authenticate
    current_user
  rescue ActiveRecord::RecordNotFound
    redirect_to error_path
  end

  def current_user
    @current_user ||= Principal.find(auth_token)
  end

  def auth_token
    params[:principal_token] || params[:token]
  end
end
