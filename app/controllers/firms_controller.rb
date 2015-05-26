class FirmsController < PrincipalsBaseController
  def index
    if current_principle.subsidiaries?
      @firm = current_principle.lookup_firm
    else
      redirect_to edit_principal_firm_questionnaire_path(current_principle, current_principle.firm)
    end
  end
end
