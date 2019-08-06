VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!

  config.filter_sensitive_data('<API_KEY>') { ENV['GOOGLE_GEOCODER_API_KEY'] }

  config.around_http_request do |request|
    uri = URI(request.uri)

    if uri.host =~ /google/
      filtered_query = CGI.parse(uri.query).except('key').to_query
      cassette_name = "/google/#{uri.path}/#{filtered_query}"
      VCR.use_cassette(
        cassette_name,
        match_requests_on: [
          :uri,
          VCR.request_matchers.uri_without_param(:key)
        ],
        record: :new_episodes,
        &request
      )
    else
      request.proceed
    end
  end

  config.ignore_request do |req|
    req.uri.include?('register.fca')
  end
end
