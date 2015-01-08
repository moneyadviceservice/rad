class FirmsController < ApplicationController
  def show
    if current_user.subsidiaries?
      @firm = current_user.firm
    else
      redirect_to new_principal_firm_questionnaire_path(current_user)
    end
  end
end
