module Reports
  class AuditRadFirms
    DEFAULT_FILE = '/tmp/audit_firms.csv'.freeze

    HEADERS = [
      'RAD Principle contact name',
      'RAD Firm Reference number',
      'RAD Firm name',
      'RAD Address',
      'RAD email address',
      'RAD telephone number',
      'RAD website',
      'Date firm was added to the MAS directory'
    ].freeze

    def initialize(csv_file: DEFAULT_FILE)
      @csv_file = csv_file
    end

    def to_csv
      CSV.open(@csv_file, 'wb') do |csv|
        csv << HEADERS

        Firm.find_each(batch_size: 500) do |firm|
          csv << row(firm)
        end
      end
    end

    def row(firm)
      [
        firm.principal.full_name,
        firm.fca_number,
        firm.registered_name,
        format_address(firm),
        firm.main_office.try(:email_address),
        firm.main_office.try(:telephone_number),
        firm.website_address,
        I18n.l(firm.created_at, format: :long)
      ]
    end

    private

    def format_address(firm)
      return '' if firm.main_office.blank?

      address = Office::ADDRESS_FIELDS.map do |field|
        firm.main_office.send(field)
      end

      address.reject(&:blank?).join(' - ')
    end
  end
end
