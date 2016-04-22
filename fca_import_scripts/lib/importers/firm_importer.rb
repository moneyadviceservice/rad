module Importers
  class FirmImporter
    def can_process?(header)
      'Firm Authorisation' == header
    end

    def copy
      "COPY #{table_name} (fca_number, registered_name, created_at, updated_at) FROM stdin;"
    end

    def record_active?(row)
      # Col 19 - Current Authorisation Status code
      ['Authorised', 'Registered', 'EEA Authorised'].include?(row[COLUMNS::FIRM_AUTHORISATION_STATUS_CODE])
    end

    def table_name
      'lookup_import_firms'
    end
  end
end
