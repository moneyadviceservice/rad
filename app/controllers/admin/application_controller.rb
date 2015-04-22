class Admin::ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  layout 'admin'

  before_action :authenticate, if: -> { HttpAuthentication.required? }

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      HttpAuthentication.authenticate(username, password)
    end
  end
end
