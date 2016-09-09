module River
  VERSION = '0.1'.freeze

  def self.source(filename)
    Core.new(filename).source
  end
end

require_relative 'river/core'
