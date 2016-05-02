module Importers
  class AdviserImporter
    def can_process?(header)
      'Individual Details' == header
    end

    def copy
      Lookup::Import::Adviser.fca_import_copy_statement
    end

    def record_active?(row)
      row[COLUMNS::ADVISER_STATUS_CODE] == '4' # Value 4 means 'Active'
    end

    def table_name
      Lookup::Import::Adviser.table_name
    end
  end
end
