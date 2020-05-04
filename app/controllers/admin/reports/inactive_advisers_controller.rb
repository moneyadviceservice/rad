class Admin::Reports::InactiveAdvisersController < Admin::ApplicationController
  def show
    @inactive_advisers = find_inactive_advisers
    respond_to do |format|
      format.html
      format.csv
    end
  end

  private

  def find_inactive_advisers
    AdvisersRetirementFirm
      .joins('LEFT JOIN lookup_advisers ' \
             'ON lookup_advisers.reference_number = advisers_retirement_firms.reference_number')
      .where('lookup_advisers.id' => nil,
             'advisers_retirement_firms.bypass_reference_number_check' => false)
  end
end
