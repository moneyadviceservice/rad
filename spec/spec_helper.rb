ENV['RAILS_ENV'] = 'test'

require_relative '../config/environment'

require 'rspec/rails'
require 'capybara/poltergeist'

Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each { |f| require f }

Faker::Config.locale = 'en-GB'

Capybara.javascript_driver = :poltergeist

RSpec.configure do |c|
  c.include Rails.application.routes.url_helpers

  c.infer_base_class_for_anonymous_controllers = false
  c.use_transactional_fixtures = false
  c.order = 'random'
  c.run_all_when_everything_filtered = true
  c.disable_monkey_patching!

  c.include FactoryGirl::Syntax::Methods
end
