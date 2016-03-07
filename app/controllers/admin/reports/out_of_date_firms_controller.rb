module Admin
  module Reports
    class OutOfDateFirmsController < Admin::ApplicationController
      REGISTERED_NAMES_TO_IGNORE = ['Acorn Financial Services',
                                    'West Country Financial',
                                    'Muir Consultancy',
                                    'WEB Financial Services Limited',
                                    'Stephen MacLeod',
                                    'Andrew Langdale',
                                    'Melfyn Parry',
                                    'David Francis Myers',
                                    'Old Mutual Wealth Private Client Limited',
                                    'Birchwood Financial Services',
                                    'Assured Future',
                                    "Damian Charles O'Connor",
                                    'Mark Geoffrey Ingham']

      def show
        @firms = Firm.joins('JOIN lookup_firms ON lookup_firms.fca_number = firms.fca_number')
                 .where(parent: nil)
                 .where('firms.registered_name != lookup_firms.registered_name')
                 .where('firms.registered_name NOT IN (?)', REGISTERED_NAMES_TO_IGNORE)
                 .order('firms.fca_number ASC')
                 .pluck('firms.fca_number', 'firms.registered_name', 'firms.id', 'lookup_firms.registered_name')
      end
    end
  end
end
