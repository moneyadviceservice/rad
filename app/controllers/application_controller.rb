class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def display_adviser_sign_in?
    false
  end

  helper_method :display_adviser_sign_in?

  end
