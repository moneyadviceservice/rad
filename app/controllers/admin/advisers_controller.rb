class Admin::AdvisersController < Admin::ApplicationController
  def index
    @advisers = if firm
                  firm.advisers
                else
                  Adviser.all
                end

    @advisers = @advisers.page(params[:page]).per(20)
  end

  private

  def firm
    @firm ||= if params[:firm_id]
                Firm.find(params[:firm_id])
              end
  end
  helper_method :firm
end
