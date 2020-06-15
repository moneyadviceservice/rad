class Admin::PrincipalsController < Admin::ApplicationController
  def index
    @search = collection.ransack(params[:q])
    @principals = @search.result.page(params[:page]).per(20)
  end

  def show
    @principal = principal
    @user = User.find_by(principal_token: principal.token)
  end

  def edit
    @principal = principal
  end

  def update
    @principal = principal

    if @principal.update_attributes(principal_params)
      redirect_to resource_path
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find_by(principal: principal)

    message = destroy_message(principal)

    ActiveRecord::Base.transaction do
      user.principal.destroy!
      user.destroy!
    end

    redirect_to collection_path, notice: message
  end

  private

  def principal
    Principal.find(params[:id])
  end

  def destroy_message(principal)
    "Successfully deleted #{principal.full_name} and all associated firms."
  end

  def principal_params
    params.require(:principal).permit(:first_name,
                                      :last_name,
                                      :fca_number,
                                      :job_title,
                                      :email_address,
                                      :telephone_number,
                                      :confirmed_disclaimer)
  end

  def collection
    Principal.all
  end
end
