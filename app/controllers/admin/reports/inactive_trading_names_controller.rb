module Admin
  module Reports
    class InactiveTradingNamesController < Admin::ApplicationController
      def show
        @inactive_trading_names = Firm
                                  .joins('LEFT JOIN lookup_subsidiaries ' \
                                         'ON lookup_subsidiaries.fca_number = firms.fca_number ' \
                                         'AND lookup_subsidiaries.name = firms.registered_name')
                                  .where('lookup_subsidiaries.id' => nil)
                                  .where.not('parent_id' => nil)
      end
    end
  end
end
