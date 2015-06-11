module Dashboard
  class AdvisersController < ApplicationController
    before_action :authenticate_user!

    def index
      @firm = principal.firm
      @trading_names = @firm.trading_names
    end

    def new
      @firm = Firm.find(params[:firm_id])
      @adviser = advisers.build
    end

    def create
      @firm = Firm.find(params[:firm_id])
      @adviser = advisers.build(adviser_params)
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
      @firm = Firm.find(params[:firm_id])
      @adviser = advisers.find(params[:id])
    end

    def update
      @firm = Firm.find(params[:firm_id])
      @adviser = advisers.find(params[:id])

      @adviser.update(adviser_params) && flash[:notice] = I18n.t('dashboard.adviser_edit.saved')

      render :edit
    end

    private

    def principal
      current_user.principal
    end

    def advisers
      Firm.find_by(id: params[:firm_id], fca_number: principal.fca_number)
        .advisers
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
