class Admin::Reports::OutOfDateFirmsController < Admin::ApplicationController
  def index
    @firms = find_out_of_date_firms
  end

  def update
    firm        = Firm.find(params[:id])
    old_name    = firm.registered_name
    lookup_firm = ::Lookup::Firm.find_by!(fca_number: firm.fca_number)

    firm.registered_name = lookup_firm.registered_name
    firm.save!

    redirect_to admin_reports_out_of_date_firms_path,
                notice: "Updated '#{old_name}' "\
                        "to '#{lookup_firm.registered_name}'"
  end

  private

  def find_out_of_date_firms
    Firm
      .joins('JOIN lookup_firms ON lookup_firms.fca_number = firms.fca_number')
      .where(parent: nil)
      .where('firms.registered_name != lookup_firms.registered_name')
      .order('firms.fca_number ASC')
      .pluck('firms.fca_number',
             'lookup_firms.registered_name',
             'firms.registered_name',
             'firms.id')
  end
end
