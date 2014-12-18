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

  def display_primary_footer?
    false
  end

  helper_method :display_primary_footer?

  private

  def authenticate
    authenticate_token or redirect_to(error_path) unless current_user
  end

  def current_user
    @current_user ||= Principal.find(session[:user_id]) if session.key?(:user_id)
  end

  def authenticate_token
    sign_in(Principal.find_by(token: params[:token]))
  end

  def sign_in(user)
    return unless user
    session[:user_id] = user.id
    user.update!(last_sign_in_at: Time.now)
    @current_user = user
  end
end
