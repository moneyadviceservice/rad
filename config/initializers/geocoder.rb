Geocoder.configure(
  lookup: :google,
  use_https: Rails.env.production?,
  api_key: ENV['GOOGLE_GEOCODER_API_KEY'],
  cache: Rails.env.production? ? Redis.new(url: ENV['REDISTOGO_URL']) : nil
)
