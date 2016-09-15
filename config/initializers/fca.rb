require File.join(Rails.root, 'lib/fca.rb')

FCA::Config.configure do |config|
  config.log_level = ENV['FCA_LOG_LEVEL']
  config.log_file  = ENV['FCA_LOG_FILE']
  config.emails    = ENV['FCA_EMAILS']
end
