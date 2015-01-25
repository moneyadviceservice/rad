class FirmsController < ApplicationController
  def index
    if current_user.subsidiaries?
      @firm = current_user.lookup_firm
    else
      redirect_to edit_principal_firm_questionnaire_path(current_user, current_user.firm)
    end
  end
end
