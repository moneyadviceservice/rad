module SelfService
  class AdvisersController < ApplicationController
    before_action :authenticate_user!
    before_action -> { @firm = current_firm }, except: [:index]

    def index
      @firm = principal.firm
      @trading_names = @firm.trading_names
    end

    def new
      @adviser = @firm.advisers.build
    end

    def create
      @adviser = @firm.advisers.build(adviser_params)
      @adviser.confirmed_disclaimer = true
      # ^^^ This needs to be resolved by some heavier refactoring
      # work across mas-rad_core and this codebase.
      if @adviser.save
        flash[:notice] = I18n.t('dashboard.adviser_edit.saved')
        render :edit
      else
        render :new
      end
    end

    def edit
      @adviser = @firm.advisers.find(params[:id])
    end

    def update
      @adviser = @firm.advisers.find(params[:id])
      @adviser.update(adviser_params) && flash[:notice] = I18n.t('dashboard.adviser_edit.saved')

      render :edit
    end

    private

    def principal
      current_user.principal
    end

    def current_firm
      Firm.find_by(id: params[:firm_id], fca_number: principal.fca_number)
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
