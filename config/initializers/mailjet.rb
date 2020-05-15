if Rails.env.production? || Rails.env.staging?
  Mailjet.configure do |config|
    config.api_key = ENV['MAILJET_API_KEY']
    config.secret_key = ENV['MAILJET_SECRET_KEY']
    config.default_from = 'RADenquiries@moneyadviceservice.org.uk'
  end
end
