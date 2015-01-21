class AdvisersController < ApplicationController
  def new
    @adviser = current_user.firm.advisers.build
  end
end
