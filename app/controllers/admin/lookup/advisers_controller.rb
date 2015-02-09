class Admin::Lookup::AdvisersController < Admin::ApplicationController
  def index
    @search = ::Lookup::Adviser.ransack(params[:q])
    @advisers = @search.result.page(params[:page]).per(20)
  end
end
