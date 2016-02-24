module SelfService
  class OfficesController < ApplicationController
    before_action :authenticate_user!
    before_action -> { @firm = current_firm }
    before_action -> { @office = current_office }, only: [:edit, :update, :destroy]

    def index
    end

    def new
      @office = @firm.offices.build
    end

    def create
      @office = @firm.offices.build(office_params)
      if @office.save_with_geocoding
        flash[:notice] = I18n.t('self_service.office_add.saved')
        redirect_to self_service_firm_offices_path(@firm)
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @office.update_with_geocoding(office_params)
        flash[:notice] = I18n.t('self_service.office_edit.saved')
        redirect_to edit_self_service_firm_office_path(@firm, @office)
      else
        render :edit
      end
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

    def office_params
      params.require(:office).permit(
        :address_line_one,
        :address_line_two,
        :address_town,
        :address_county,
        :address_postcode,
        :email_address,
        :telephone_number,
        :disabled_access
      )
    end
  end
end
