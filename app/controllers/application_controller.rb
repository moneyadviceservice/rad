class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :check_for_lockup, if: -> { Rails.env.staging? }
  before_action :configure_permitted_parameters, if: :devise_controller?

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
    if current_user && current_user.principal.travel_insurance_firm
      ENV['TAD_ADMIN_EMAIL']
    else
      ENV['RAD_ADMIN_EMAIL']
    end
  end

  helper_method :admin_email_address
end
