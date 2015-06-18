class SubsidiariesController < PrincipalsBaseController
  before_action :authenticate_user!

  def convert
    firm = current_principle.find_or_create_subsidiary(params[:id])

    redirect_to edit_principal_firm_questionnaire_path(current_principle, firm)
  end
end
