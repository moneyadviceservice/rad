module Cloud
  VERSION = '0.1'.freeze

  class ConfigError < ArgumentError; end
end

require_relative 'cloud/config'
require_relative 'cloud/providers'
require_relative 'cloud/storage'
