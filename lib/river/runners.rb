require_relative 'runners/tempfile'

module River
  module Runners
    def self.fetch(k, &blk)
      mapping.fetch(k) { blk.call }
    end

    def self.all
      mapping.keys
    end

    def self.mapping
      { tempfile: River::Runners::Tempfile }
    end
  end
end
