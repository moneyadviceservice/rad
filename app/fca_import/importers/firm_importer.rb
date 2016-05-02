module Importers
  class FirmImporter
    def can_process?(header)
      'Firm Authorisation' == header
    end

    def record_active?(row)
      # Col 19 - Current Authorisation Status code
      ['Authorised', 'Registered', 'EEA Authorised'].include?(row[COLUMNS::FIRM_AUTHORISATION_STATUS_CODE])
    end

    def model_class
      Lookup::Import::Firm
    end
  end
end
