class Admin::PrincipalsController < Admin::ApplicationController
  def index
    @search = Principal.ransack(params[:q])
    @principals = @search.result.page(params[:page]).per(20)
  end

  def show
    @principal = principal
  end

  def edit
    @principal = principal
  end

  def update
    @principal = principal

    if @principal.update(principal_params)
      render 'show'
    else
      render 'edit'
    end
  end

  private

  def principal
    Principal.find(params[:id])
  end

  def principal_params
    params.require(:principal).permit(:website_address)
  end
end
