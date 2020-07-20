require 'csv'

module Reports
  class FirmsExport
    HEADER_ROW = [
      'FRN Number',
      'Principal Name',
      'Email address',
      'Status'
    ].freeze

    def initialize(firms)
      @firms = firms
    end

    def generate_csv
      CSV.generate do |csv|
        csv << HEADER_ROW

        @firms.each do |firm|
          csv << [
            firm.fca_number,
            [firm.principal.first_name, firm.principal.last_name].join(' '),
            firm.principal.email_address,
            firm.status
          ]
        end
      end
    end
  end
end
