class SubsidiariesController < ApplicationController
  def convert
    subsidiary = current_user.lookup_firm.subsidiaries.find(params[:id])
    firm = current_user.firm.subsidiaries.find_or_initialize_by(
      registered_name: subsidiary.name,
      fca_number: subsidiary.fca_number
    )

    firm.save(validate: false) unless firm.persisted?

    redirect_to edit_principal_firm_questionnaire_path(current_user, firm)
  end
end
