source 'https://rubygems.org'

# force bundler to use HTTPS
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read('.ruby-version').chomp

# RULES OF THE GEMFILE
#
# 1. Consult contributors before adding a dependency
# 2. Keep dependencies ordered alphabetically
# 3. Place dependencies in the group they belong
# 4. Only use version specifiers where appropriate

gem 'rails', '~> 5.2.8'

gem 'active_link_to'
gem 'active_model_serializers', '~> 0.10.1'
gem 'algoliasearch'
gem 'azure-storage'
gem 'bootstrap-sass'
gem 'bowndler', github: 'moneyadviceservice/bowndler'
gem 'devise', '~> 4.7.1'
gem 'devise-security', '~> 0.13'
# Dough assets are loaded from a CDN instead of from the Gem. Do make sure that
# the CDN version is the same as the Gem version.
gem 'dough-ruby', github: 'moneyadviceservice/dough', branch: 'html-options-fix', ref: 'c84c153'
gem 'geocoder', '>= 1.6.1'
gem 'httpclient', '~> 2.8.3'
gem 'jquery-rails'
gem 'kaminari'
gem 'kaminari-bootstrap3'
gem 'language_list', '~> 1.2.1'
gem 'lockup'
gem 'mailjet'
gem 'mimemagic', '~> 0.3'
gem 'oga'
gem 'pg', '~> 0.20.0'
gem 'puma'
gem 'rack-rewrite'
gem 'rails_email_validator'
gem 'ransack'
gem 'redis'
gem 'rollbar'
gem 'rubyzip', '~> 1.3'
gem 'sass-rails'
gem 'sidekiq'
gem 'sidekiq-unique-jobs', '~> 6.0.16'
gem 'statsd-ruby', '~> 1.4.0'
gem 'uglifier', '>= 1.3.0'
gem 'uk_phone_numbers', '~> 0.1.1'
gem 'uk_postcode', '~> 2.1.2'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
  gem 'listen'
  gem 'rails-erd'
  gem 'solargraph'
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test, :development do
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'ffaker'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rb-readline'
  gem 'rspec-rails'
  gem 'rubocop', '0.80.0', require: false
end

group :test do
  gem 'brakeman', require: false
  gem 'capybara'
  gem 'danger', require: false
  gem 'danger-rubocop', require: false
  gem 'database_cleaner'
  gem 'launchy'
  gem 'rspec-collection_matchers'
  gem 'rspec-sidekiq'
  gem 'shoulda-matchers', '~> 4.0'
  gem 'site_prism'
  gem 'timecop'
  gem 'tzinfo-data'
  gem 'vcr'
  gem 'webmock', '3.5.0'
end
