class Admin::ApplicationController < ApplicationController
  protect_from_forgery with: :exception

  layout 'admin'
end
