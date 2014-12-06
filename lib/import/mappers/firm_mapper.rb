module Import::Mappers
  class FirmMapper
    FCA_NUMBER = 0
    REGISTERED_NAME = 1

    def initialize(model_class)
      @model_class = model_class
    end

    def call(row)
      @model_class.create!(
        fca_number:      row[FCA_NUMBER],
        registered_name: row[REGISTERED_NAME]
      )
    end
  end
end
