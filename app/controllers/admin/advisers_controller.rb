class Admin::AdvisersController < Admin::ApplicationController
  def index
    @search = Adviser.ransack(params[:q])
    @advisers = @search.result

    if firm
      @advisers = @advisers.where(:firm_id => firm)
    end

    @advisers = @advisers.page(params[:page]).per(20)
  end

  def show
    @adviser = Adviser.find(params[:id])
  end

  private

  def firm
    @firm ||= if params[:firm_id]
                Firm.find(params[:firm_id])
              end
  end
  helper_method :firm
end
