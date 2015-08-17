module SelfService
  class OfficesController < ApplicationController
    before_action :authenticate_user!
    before_action -> { @firm = current_firm }
    before_action -> { @office = current_office }, only: [:destroy]

    def index
    end

    def destroy
      @office.destroy
      flash[:notice] = I18n.t('self_service.office_destroy.deleted', postcode: @office.address_postcode)

      redirect_to :back
    end

    private

    def principal
      current_user.principal
    end

    def current_firm
      Firm.find_by(id: params[:firm_id], fca_number: principal.fca_number)
    end

    def current_office
      @firm.offices.find(params[:id])
    end
  end
end
