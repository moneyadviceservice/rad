module Lookup
  class Adviser < ApplicationRecord
    validates   :reference_number, length: { is: 8 }
    validates :name, presence: true

    def self.table_name
      "lookup_#{super}"
    end

    def self.ransackable_attributes(*)
      %w[created_at reference_number name]
    end

    def self.ransackable_associations(*)
      []
    end
  end
end
