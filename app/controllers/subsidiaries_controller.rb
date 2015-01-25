class SubsidiariesController < ApplicationController
  def convert
    firm = current_user.find_or_create_subsidiary(params[:id])

    redirect_to edit_principal_firm_questionnaire_path(current_user, firm)
  end
end
