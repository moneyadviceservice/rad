module Importers
  class FirmImporter
    def can_process?(header)
      'Firm Authorisation' == header
    end

    def copy
      Lookup::Import::Firm.fca_import_copy_statement
    end

    def record_active?(row)
      # Col 19 - Current Authorisation Status code
      ['Authorised', 'Registered', 'EEA Authorised'].include?(row[COLUMNS::FIRM_AUTHORISATION_STATUS_CODE])
    end

    def table_name
      Lookup::Import::Firm.table_name
    end
  end
end
