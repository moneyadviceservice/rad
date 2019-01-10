module Lookup
  class Adviser < ActiveRecord::Base
    validates   :reference_number, length: { is: 8 }
    validates :name, presence: true

    def self.table_name
      "lookup_#{super}"
    end
  end
end
