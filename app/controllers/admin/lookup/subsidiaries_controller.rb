class Admin::Lookup::SubsidiariesController < Admin::ApplicationController
  def index
    @search = ::Lookup::Subsidiary.ransack(params[:q])
    @subsidiaries = @search.result.page(params[:page]).per(20)
  end
end
