VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

def vcr_options_for(cassette_name)
  { cassette_name: cassette_name, record: :new_episodes }
end
