class FirmsController < ApplicationController
  def show
    if current_user.subsidiaries?
      @firm = current_user.lookup_firm
    else
      redirect_to edit_principal_firm_questionnaire_path(current_user)
    end
  end
end
