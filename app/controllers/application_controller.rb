class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

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

  def display_adviser_sign_in?
    false
  end

  helper_method :display_adviser_sign_in?
end
