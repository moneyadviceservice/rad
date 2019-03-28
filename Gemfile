source 'https://rubygems.org'

ruby File.read('.ruby-version').chomp

# RULES OF THE GEMFILE
#
# 1. Consult contributors before adding a dependency
# 2. Keep dependencies ordered alphabetically
# 3. Place dependencies in the group they belong
# 4. Only use version specifiers where appropriate

gem 'rails', '4.2.11.1'

gem 'active_link_to'
gem 'active_model_serializers', '~> 0.10.1'
gem 'azure-storage'
gem 'bootstrap-sass'
gem 'bowndler', github: 'moneyadviceservice/bowndler'
gem 'devise', '~> 4.5.0'
gem 'devise-security', '~> 0.13'
gem 'devise_invitable', '1.6.1'
# Dough assets are loaded from a CDN instead of from the Gem. Do make sure that
# the CDN version is the same as the Gem version.
gem 'dough-ruby',
    github: 'moneyadviceservice/dough',
    require: 'dough',
    tag: 'v5.12.0.267'
gem 'geocoder', '~> 1.4.7'
gem 'httpclient', '~> 2.8.3'
gem 'jquery-rails'
gem 'kaminari'
gem 'language_list', '~> 1.2.1'
gem 'letter_opener', group: :development
gem 'mailjet'
gem 'oga'
gem 'pg', '0.21.0'
gem 'rails_email_validator'
gem 'rake', '~> 11'
gem 'ransack'
# Adding `redis` as a direct dependency to highlight the fact that `sidekiq` in
# version `3.3.4` has a very loose lock for `redis`, which causes the bug
# described at: https://github.com/antirez/redis/issues/4272
# N.B.: it will possibly need to be removed as soon as we bump `sidekiq` to the
# latest version
gem 'redis', '~> 3.3.5'
gem 'rollbar'
gem 'rubyzip'
gem 'sass-rails'
gem 'sidekiq', '~> 3.3.4'
gem 'sidekiq-unique-jobs'
gem 'sidetiq'
gem 'sinatra', require: false
gem 'slack-ruby-client'
gem 'statsd-ruby', '~> 1.4.0'
gem 'uglifier', '>= 1.3.0'
gem 'uk_phone_numbers', '~> 0.1.1'
gem 'uk_postcode', '~> 2.1.2'
gem 'unicorn'

group :test, :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'ffaker'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rubocop', '0.54.0'
  gem 'timecop'
end

group :test do
  gem 'brakeman', require: false
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'danger', require: false
  gem 'danger-rubocop', require: false
  gem 'database_cleaner'
  gem 'launchy'
  gem 'poltergeist'
  gem 'rspec-collection_matchers'
  gem 'site_prism'
  gem 'tzinfo-data'
  gem 'vcr'
  gem 'webmock'
end
