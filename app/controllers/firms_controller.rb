class FirmsController < ApplicationController
  def show
    redirect_to new_principal_firm_questionnaire_path(current_user)
  end
end
