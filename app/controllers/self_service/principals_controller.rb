module SelfService
  class PrincipalsController < ApplicationController
    before_action :authenticate_user!
    before_action -> { @principal = principal }

    def edit
      @firm = principal.firm
    end

    def update
      if principal.update(principal_params)
        flash[:notice] = I18n.t('self_service.principal_edit.saved')
        redirect_to edit_self_service_principal_path(principal)
      else
        render :edit
      end
    end

    private

    def principal
      fail ActiveRecord::RecordNotFound unless current_user.principal.id == params[:id]
      current_user.principal
    end

    def principal_params
      params.require(:principal).permit(
        :first_name,
        :last_name,
        :email_address,
        :telephone_number,
        :job_title
      )
    end
  end
end
