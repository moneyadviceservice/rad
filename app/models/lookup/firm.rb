module Lookup
  class Firm < ActiveRecord::Base
    validates :fca_number,
      length: { is: 6 },
      numericality: { only_integer: true }

    def self.table_name
      "lookup_#{super}"
    end
  end
end
