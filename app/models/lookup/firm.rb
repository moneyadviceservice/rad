module Lookup
  class Firm < ActiveRecord::Base
    has_many :subsidiaries, primary_key: :fca_number, foreign_key: :fca_number

    def self.table_name
      "lookup_#{super}"
    end
  end
end
