class Admin::FirmsController < Admin::ApplicationController
  def index
    @search = Firm.ransack(params[:q])
    @firms = @search.result.page(params[:page]).per(20)
  end

  def show
    @firm = Firm.find(params[:id])
  end

  def login_report
    users = User.includes(principal: [:firm]).order('firms.registered_name ASC')
    @accepted_firms = users.where.not(invitation_accepted_at: nil)
    @not_accepted_firms = users.where(invitation_accepted_at: nil)
  end
end
