class Admin::MetricsController < Admin::ApplicationController
  def index
    @snapshots = Snapshot.order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
    @snapshot = Snapshot.find(params[:id])
  end
end
