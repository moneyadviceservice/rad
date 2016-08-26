module Cloud
  VERSION = '0.1'.freeze

  class ConfigError < ArgumentError; end
end

Dir[File.join(File.dirname(__FILE__), 'cloud/*')].each { |file| require file }
