ENV['RAILS_ENV'] = 'test'

require_relative '../config/environment'

require 'rspec/rails'
require 'factory_bot_rails'
require 'sidekiq/testing'
require 'capybara/rails'
require 'capybara/rspec'

Dir[File.join(File.dirname(__FILE__), 'support', '**', '*_section.rb')].each { |f| require f }
Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each { |f| require f }

require File.join(File.dirname(__FILE__), 'support/fca_test_helpers.rb')

Faker::Config.locale = 'en-GB'

Capybara.default_max_wait_time = 5

RSpec.configure do |c|
  c.include Rails.application.routes.url_helpers
  c.infer_base_class_for_anonymous_controllers = false
  c.use_transactional_fixtures = false
  c.order = 'random'
  c.run_all_when_everything_filtered = true
  c.disable_monkey_patching!

  c.include FactoryBot::Syntax::Methods

  c.around(:each, inline_job_queue: true) do |example|
    ActiveJob::Base.queue_adapter = :inline
    example.run
  ensure
    ActiveJob::Base.queue_adapter = :test
  end

  c.include FcaTestHelpers

  c.include Devise::Test::IntegrationHelpers, type: :request
  c.include Devise::Test::IntegrationHelpers, type: :feature

  c.example_status_persistence_file_path = 'spec/test_status.txt'
end

RSpec::Sidekiq.configure do |config|
  config.warn_when_jobs_not_processed_by_sidekiq = false
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
