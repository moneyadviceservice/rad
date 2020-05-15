class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :http_authenticate
  before_action :configure_permitted_parameters, if: :devise_controller?

  def http_authenticate
    return unless Rails.env.staging?

    authenticate_or_request_with_http_basic do |_, password|
      password == ENV['STAGING_BASIC_AUTH_PASSWORD']
    end
  end

  def after_sign_in_path_for(user)
    stored_location_for(user) || self_service_root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in) do |u|
      u.permit(:login, :password, :remember_me)
    end
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:email, :password, :password_confirmation, :current_password)
    end
  end

  def admin_email_address
    ENV['RAD_ADMIN_EMAIL']
  end
  helper_method :admin_email_address
end
