class Reports::FirmsAdvisers
  HEADER_ROW = [
    'FCA Number',
    'Name',
    'Principal',
    'Email Address',
    'Advice Method',
    'Adviser Count'
  ]

  def self.data
    CSV.generate do |csv|
      csv << HEADER_ROW

      Firm.includes(
        :advisers,
        :principal,
        :in_person_advice_methods,
        :other_advice_methods,
        :principal
      ).find_each do |firm|
        csv << row_for_firm(firm)
      end
    end
  end

  def self.row_for_firm(firm)
    [
      firm.fca_number,
      firm.registered_name,
      firm.principal.full_name,
      firm.principal.email_address,
      firm.primary_advice_method,
      firm.advisers.length
    ]
  end
end
