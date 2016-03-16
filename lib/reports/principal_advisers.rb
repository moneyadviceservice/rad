require 'csv'

module Reports
  class PrincipalAdvisers
    HEADER_ROW = [
      'FCA Number',
      'Principal Name',
      'Email address',
      'Adviser Count'
    ]

    def self.data
      CSV.generate do |csv|
        csv << HEADER_ROW
        Firm.joins(:principal).joins('left outer join advisers on advisers.firm_id = firms.id').select('firms.fca_number, principals.first_name, ' + 'principals.last_name, principals.email_address, count(advisers.id) as advisers_count').group('firms.fca_number, principals.first_name, principals.last_name, principals.email_address').order('advisers_count')
          .to_a.each { |principal| csv << row_for_principal(principal) }
      end
    end

    def self.row_for_principal(principal)
      [
        principal.fca_number,
        principal.first_name + ' ' + principal.last_name,
        principal.email_address,
        principal.advisers_count
      ]
    end
  end
end
