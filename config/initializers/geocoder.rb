Geocoder.configure(
  lookup: :google,
  use_https: (Rails.env.production? || Rails.env.staging?),
  api_key: ENV['GOOGLE_GEOCODER_API_KEY'],
  cache: (Rails.env.production? || Rails.env.staging?) ? Redis.new(url: ENV['REDISCLOUD_URL']) : nil
)
