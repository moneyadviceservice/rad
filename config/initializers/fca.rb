require File.join(Rails.root, 'lib/fca.rb')

FCA::Config.configure do |config|
  dev_or_test = %w(development test).include?(Rails.env)
  channel = ENV.fetch('SLACK_FCA_CHANNEL') {
    dev_or_test ? '#test-channel' : fail('Missing env var `SLACK_FCA_CHANNEL`')
  }
  config.log_level = ENV.fetch('FCA_LOG_LEVEL', :info)
  config.log_file  = ENV.fetch('FCA_LOG_FILE', $stdout)
  config.notify    = { slack: { channel: channel } }
  config.hostname  = ENV.fetch('RAD_HOSTNAME') {
    dev_or_test ? 'localhost' : fail('Missing env var `RAD_HOSTNAME`')
  }
end
