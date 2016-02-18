class Reports::Firms
  HEADER_ROW = [
    'FCA Number',
    'Name',
    'Principal',
    'Email Address',
    'Advice Method',
    'Adviser Count'
  ]

  def data
    CSV.generate do |csv|
      csv << HEADER_ROW

      Firm.all.each do |firm|
        csv << row_for_firm(firm)
      end
    end
  end

  private

  def row_for_firm(firm)
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
