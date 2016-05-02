module Importers
  class AdviserImporter
    def can_process?(header)
      'Individual Details' == header
    end

    def record_active?(row)
      row[COLUMNS::ADVISER_STATUS_CODE] == '4' # Value 4 means 'Active'
    end

    def model_class
      Lookup::Import::Adviser
    end
  end
end
