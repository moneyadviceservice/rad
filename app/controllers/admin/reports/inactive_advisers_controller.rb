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
    Adviser
      .joins('LEFT JOIN lookup_advisers ' \
             'ON lookup_advisers.reference_number = advisers.reference_number')
      .where('lookup_advisers.id' => nil,
             'advisers.bypass_reference_number_check' => false)
  end
end
