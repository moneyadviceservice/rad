require 'csv'

module Tasks
  module Reports
    def self.firms_with_out_of_date_names_as_csv
      CSV.generate do |csv|
        csv << ['FRN', 'Name in directory', 'Name in the last FCA import']
        Firm.joins('JOIN lookup_firms ON lookup_firms.fca_number = firms.fca_number')
          .where(parent: nil)
          .where('firms.registered_name != lookup_firms.registered_name')
          .order('firms.fca_number ASC')
          .pluck('firms.fca_number',
                 'firms.registered_name',
                 'lookup_firms.registered_name')
          .each { |rec| csv << rec }
      end
    end
  end
end
