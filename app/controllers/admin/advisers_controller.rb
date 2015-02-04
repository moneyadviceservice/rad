class Admin::AdvisersController < Admin::ApplicationController
  def index
    @advisers = Adviser.page(params[:page]).per(20)
  end
end
