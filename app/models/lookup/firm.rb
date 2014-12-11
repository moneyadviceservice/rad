module Lookup
  class Firm < ActiveRecord::Base
    def self.table_name
      "lookup_#{super}"
    end
  end
end
