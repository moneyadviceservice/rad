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
    @adviser = adviser
  end

  def edit
    @adviser = adviser
  end

  def update
    @adviser = adviser

    if @adviser.update(adviser_params)
      render 'show'
    else
      render 'edit'
    end
  end

  private

  def firm
    @firm ||= if params[:firm_id]
                Firm.find(params[:firm_id])
              end
  end
  helper_method :firm

  def adviser
    Adviser.find(params[:id])
  end

  def adviser_params
    params.require(:adviser).permit(:postcode)
  end
end
