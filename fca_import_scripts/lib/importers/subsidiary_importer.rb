module Importers
  class SubsidiaryImporter
    def initialize
      @seen_trading_names = Set.new
    end

    def can_process?(header)
      'Alternative Firm Name' == header
    end

    def copy
      "COPY #{table_name} (fca_number, name, created_at, updated_at) FROM stdin;"
    end

    def record_active?(row)
      row[COLUMNS::SUBSIDIARY_END_DATE].empty? && unique_trading_name?(row)
    end

    def table_name
      'lookup_import_subsidiaries'
    end

    private

    def unique_trading_name?(row)
      # Returns nil if the key already exists. Otherwise returns self.
      @seen_trading_names.add?("#{row[COLUMNS::REFERENCE_NUMBER]}|#{row[COLUMNS::NAME]}")
    end
  end
end
