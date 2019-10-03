ENV['RAILS_ENV'] = 'test'

require_relative '../config/environment'

require 'rspec/rails'
require 'factory_bot_rails'
require 'capybara/poltergeist'
require 'sidekiq/testing'

Dir[File.join(File.dirname(__FILE__), 'support', '**', '*_section.rb')].each { |f| require f }
Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each { |f| require f }

require File.join(File.dirname(__FILE__), 'support/fca_test_helpers.rb')

Faker::Config.locale = 'en-GB'

Capybara.javascript_driver = :poltergeist
Capybara.default_max_wait_time = 5

TestAfterCommit.enabled = true

RSpec.configure do |c|
  c.include Rails.application.routes.url_helpers

  c.infer_base_class_for_anonymous_controllers = false
  c.use_transactional_fixtures = false
  c.order = 'random'
  c.run_all_when_everything_filtered = true
  c.disable_monkey_patching!

  c.include FactoryBot::Syntax::Methods

  c.around(:each, inline_job_queue: true) do |example|
    begin
      ActiveJob::Base.queue_adapter = :inline
      example.run
    ensure
      ActiveJob::Base.queue_adapter = :test
    end
  end

  c.include Devise::Test::ControllerHelpers, type: :controller
  c.include Warden::Test::Helpers
  c.include FcaTestHelpers
  c.before :suite do
    Warden.test_mode!
  end
end

RSpec::Sidekiq.configure do |config|
  config.warn_when_jobs_not_processed_by_sidekiq = false
end
