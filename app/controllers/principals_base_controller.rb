class PrincipalsBaseController < ApplicationController
  before_action :load_principle

  helper_method :current_principle

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
