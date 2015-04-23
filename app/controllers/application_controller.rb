class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :load_principle


  def display_adviser_sign_in?
    false
  end

  helper_method :display_adviser_sign_in?

  helper_method :current_principle

  private

  def load_principle
    current_principle
  rescue ActiveRecord::RecordNotFound
    redirect_to error_path
  end

  def current_principle
    @current_principle ||= Principal.find(auth_token)
  end

  def auth_token
    params[:principal_token] || params[:token]
  end
end
