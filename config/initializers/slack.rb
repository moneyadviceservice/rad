require 'slack-ruby-client'

Slack.configure do |config|
  config.token = ENV.fetch('SLACK_API_TOKEN') do
    if Rails.env.test? || Rails.env.development?
      'slack-api-token'
    else
      fail('Missing ENV["SLACK_API_TOKEN"]!')
    end
  end
end
