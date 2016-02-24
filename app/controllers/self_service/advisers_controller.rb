module SelfService
  class AdvisersController < ApplicationController
    before_action :authenticate_user!
    before_action -> { @firm = current_firm }
    before_action -> { @adviser = current_adviser }, only: [:edit, :update, :destroy]

    def index
    end

    def new
      @adviser = @firm.advisers.build
    end

    def create
      @adviser = @firm.advisers.build(adviser_params)
      if @adviser.save_with_geocoding
        flash[:notice] = I18n.t('self_service.adviser_edit.saved')
        redirect_to self_service_firm_advisers_path(@firm)
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @adviser.update_with_geocoding(adviser_params)
        flash[:notice] = I18n.t('self_service.adviser_edit.saved')
        redirect_to self_service_firm_advisers_path(@firm)
      else
        render :edit
      end
    end

    def destroy
      @adviser.destroy
      flash[:notice] = I18n.t('self_service.adviser_destroy.deleted', name: @adviser.name)

      redirect_to :back
    end

    private

    def principal
      current_user.principal
    end

    def current_firm
      Firm.find_by(id: params[:firm_id], fca_number: principal.fca_number)
    end

    def current_adviser
      @firm.advisers.find(params[:id])
    end

    def adviser_params
      params.require(:adviser).permit(
        :reference_number,
        :postcode,
        :travel_distance,
        accreditation_ids: [],
        qualification_ids: [],
        professional_standing_ids: [],
        professional_body_ids: []
      )
    end
  end
end
