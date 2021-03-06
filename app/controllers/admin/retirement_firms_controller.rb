class Admin::RetirementFirmsController < Admin::BaseFirmsController
  def firms_search_path
    admin_retirement_firms_path
  end
  helper_method :firms_search_path

  def approval_path
    admin_retirement_firm_approve_path(@firm.id)
  end
  helper_method :approval_path

  def login_report
    users = User.includes(principal: [:firm]).order('firms.registered_name ASC')
    @accepted_firms = users.where.not(invitation_accepted_at: nil)
    @not_accepted_firms = users.where(invitation_accepted_at: nil)
  end

  def adviser_report
    data = ::Reports::PrincipalAdvisers.data
    time_string = Time.zone.now.to_formatted_s(:number)
    respond_to do |format|
      format.csv do
        send_data(data, filename: "firms-advisers-#{time_string}.csv")
      end
    end
  end

  def resource_path
    admin_retirement_principal_path(@firm.principal)
  end

  private

  def resource_class
    Firm.includes(:principal)
  end
end
