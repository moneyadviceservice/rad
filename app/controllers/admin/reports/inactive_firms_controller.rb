module Admin
  module Reports
    class InactiveFirmsController < Admin::ApplicationController
      def show
        @inactive_firms = Firm
                          .joins('LEFT JOIN lookup_firms ' \
                                 'ON lookup_firms.fca_number = firms.fca_number')
                          .where('lookup_firms.id' => nil, 'parent_id' => nil)
      end
    end
  end
end
