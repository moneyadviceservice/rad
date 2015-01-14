module Import::Mappers
  class AdviserMapper
    REFERENCE_NUMBER = 0
    NAME = 1

    def initialize(model_class)
      @model_class = model_class
    end

    def call(row)
      @model_class.create!(
        reference_number: row[REFERENCE_NUMBER],
        name: row[NAME]
      )
    end
  end
end
