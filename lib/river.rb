module River
  VERSION = '1.0'.freeze

  def self.source(context = {})
    Core.new(context)
  end
end

require_relative 'river/core'
