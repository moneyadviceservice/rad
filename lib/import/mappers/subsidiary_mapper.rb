module Import::Mappers
  class SubsidiaryMapper
    FCA_NUMBER = 0
    NAME = 1

    def initialize(model_class)
      @model_class = model_class
    end

    def call(row)
      @model_class.create!(
        fca_number: row[FCA_NUMBER],
        name: row[NAME]
      )
    end
  end
end
