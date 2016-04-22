module Importers
  class AdviserImporter
    def can_process?(header)
      'Individual Details' == header
    end

    def copy
      "COPY #{table_name} (reference_number, name, created_at, updated_at) FROM stdin;"
    end

    def record_active?(row)
      row[COLUMNS::ADVISER_STATUS_CODE] == '4' # Value 4 means 'Active'
    end

    def table_name
      'lookup_import_advisers'
    end
  end
end
