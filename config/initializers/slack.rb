require 'slack-ruby-client'

Slack.configure do |config|
  config.token = ENV.fetch('SLACK_API_TOKEN') {
    Rails.env == test ? 'slack-api-token' : fail('Missing ENV[SLACK_API_TOKEN]!')
  }  
end
