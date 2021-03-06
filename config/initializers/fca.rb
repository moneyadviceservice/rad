require File.join(Rails.root, 'lib/fca.rb')

FCA::Config.configure do |config|
  dev_or_test = %w(development test).include?(Rails.env)
  config.log_level = ENV.fetch('FCA_LOG_LEVEL', :info)
  config.log_file  = ENV.fetch('FCA_LOG_FILE', $stdout)
  config.hostname  = ENV.fetch('RAD_HOSTNAME') {
    dev_or_test ? 'localhost' : fail('Missing env var `RAD_HOSTNAME`')
  }
  config.email_recipients  = ENV.fetch('FCA_IMPORT_EMAILS') {
    dev_or_test ? 'dev@moneyadviceservice.org.uk' : fail('Missing env var `FCA_IMPORT_EMAILS` email1, email2, ...')
  }
end
