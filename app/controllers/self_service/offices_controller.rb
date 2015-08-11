module SelfService
  class OfficesController < ApplicationController
    before_action :authenticate_user!
  end
end
