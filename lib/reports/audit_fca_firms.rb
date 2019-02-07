module Reports
  class FcaRow
    attr_reader :row

    def initialize(row)
      @row = row
    end

    def firm_reference_number
      row[0]
    end

    def firm_name
      row[1]
    end

    def telephone_number
      [row[13], row[14], row[15]].join(' ').tr(',', ' ')
    end

    def mobile_number
      [row[16], row[17], row[18]].join(' ').tr(',', ' ')
    end

    def address
      [row[5], row[6], row[9], row[11], row[12]].reject(&:blank?).join(' - ')
    end
  end

  class AuditFcaFirms
    HEADERS = [
      'Fca Firm Reference number',
      'Fca Firm name',
      'Telephone number',
      'Mobile number',
      'Fca Address'
    ].freeze
    DEFAULT_FILE = '/tmp/audit_fca_firms.csv'.freeze

    def initialize(fca_file:, csv_file: DEFAULT_FILE)
      @lines = File.read(File.expand_path(fca_file))
      @csv_file = csv_file
    end

    def to_csv
      CSV.open(@csv_file, 'wb') do |csv|
        csv << HEADERS
        rows.each do |row|
          csv << [
            row.firm_reference_number,
            row.firm_name,
            row.telephone_number,
            row.mobile_number,
            row.address
          ]
        end
      end
    end

    def rows
      @lines.each_line.to_a[1..-1].map do |line|
        FcaRow.new(line.force_encoding('ISO-8859-1').split('|'))
      end
    end
  end
end
