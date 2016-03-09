module Admin
  module Reports
    class InactiveAdvisersController < Admin::ApplicationController
      def show
        @inactive_advisers = Adviser
                             .joins('LEFT JOIN lookup_advisers ' \
                                   'ON lookup_advisers.reference_number = advisers.reference_number')
                             .where('lookup_advisers.id' => nil,
                                    'advisers.bypass_reference_number_check' => false)
      end
    end
  end
end