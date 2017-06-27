class Admin::Reports::InactiveTradingNamesController < Admin::ApplicationController
  def show
    @inactive_trading_names = find_inactive_trading_names
    respond_to do |format|
      format.html
      format.csv
    end
  end

  private

  def find_inactive_trading_names
    Firm
      .joins('LEFT JOIN lookup_subsidiaries ' \
             'ON lookup_subsidiaries.fca_number = firms.fca_number ' \
             'AND lookup_subsidiaries.name = firms.registered_name')
      .where('lookup_subsidiaries.id' => nil)
      .where.not('parent_id' => nil)
  end
end
