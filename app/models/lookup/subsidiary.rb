module Lookup
  class Subsidiary < ActiveRecord::Base
    def self.table_name
      "lookup_#{super}"
    end
  end
end
