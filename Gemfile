source 'https://rubygems.org'

ruby '2.2.2'

# RULES OF THE GEMFILE
#
# 1. Consult contributors before adding a dependency
# 2. Keep dependencies ordered alphabetically
# 3. Place dependencies in the group they belong
# 4. Only use version specifiers where appropriate

gem 'rails', '4.2.10'

gem 'active_link_to'
gem 'active_model_serializers', '~> 0.10.1'
gem 'azure-storage'
gem 'bootstrap-sass'
gem 'bowndler', github: 'moneyadviceservice/bowndler'
gem 'devise'
gem 'devise_invitable'
gem 'devise_security_extension'
# Dough assets are loaded from a CDN instead of from the Gem. Do make sure that
# the CDN version is the same as the Gem version.
gem 'dough-ruby',
    github: 'moneyadviceservice/dough',
    require: 'dough',
    tag: 'v5.12.0.267'
gem 'geocoder'
gem 'httpclient'
gem 'jquery-rails'
gem 'kaminari'
gem 'language_list'
gem 'letter_opener', group: :development
gem 'mailjet'
gem 'oga'
gem 'pg', '< 1.0.0'
gem 'rails_email_validator'
gem 'rake', '~> 11'
gem 'ransack'
gem 'redis'
gem 'rollbar'
gem 'rubyzip'
gem 'sass-rails'
gem 'sidekiq', '~> 3.3.4'
gem 'sidekiq-unique-jobs'
gem 'sidetiq'
gem 'sinatra', require: false
gem 'slack-ruby-client'
gem 'statsd-ruby'
gem 'uglifier', '>= 1.3.0'
gem 'unicorn'
gem 'uk_phone_numbers'
gem 'uk_postcode'

group :test, :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'ffaker'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
    gem 'rubocop', '0.49.0'
  gem 'timecop'
end

group :test do
  gem 'brakeman', require: false
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'launchy'
  gem 'poltergeist'
  gem 'rspec-collection_matchers'
  gem 'site_prism'
  gem 'tzinfo-data'
  gem 'vcr'
  gem 'webmock'
end
