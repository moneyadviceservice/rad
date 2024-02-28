module Lookup
  class Subsidiary < ApplicationRecord
    validates :fca_number,
              length: { is: 6 },
              numericality: { only_integer: true }

    def self.table_name
      "lookup_#{super}"
    end

    def self.ransackable_attributes(*)
      %w[created_at fca_number name]
    end

    def self.ransackable_associations(*)
      []
    end
  end
end
