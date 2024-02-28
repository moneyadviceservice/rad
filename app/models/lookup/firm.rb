module Lookup
  class Firm < ApplicationRecord
    has_many :subsidiaries, primary_key: :fca_number, foreign_key: :fca_number

    validates :fca_number,
              length: { is: 6 },
              numericality: { only_integer: true }

    def subsidiaries?
      subsidiaries.present?
    end

    def self.table_name
      "lookup_#{super}"
    end

    def self.ransackable_attributes(*)
      %w[created_at fca_number registered_name]
    end

    def self.ransackable_associations(*)
      ['subsidiaries']
    end
  end
end
