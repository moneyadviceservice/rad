source 'https://rubygems.org'

ruby '2.2.2'

# RULES OF THE GEMFILE
#
# 1. Consult contributors before adding a dependency
# 2. Keep dependencies ordered alphabetically
# 3. Place dependencies in the group they belong
# 4. Only use version specifiers where appropriate

gem 'rails', '~> 4.2.5.2'

gem 'active_link_to'
gem 'bootstrap-sass', '~> 3.3.3'
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
gem 'jquery-rails'
gem 'kaminari'
gem 'letter_opener', group: :development
gem 'mailjet'
gem 'mas-rad_core', '0.0.109'
gem 'oga'
gem 'pg'
gem 'rails_email_validator'
gem 'ransack'
gem 'rollbar'
gem 'sass-rails'
gem 'sidekiq'
gem 'sidetiq'
gem 'sinatra', require: false
gem 'uglifier', '>= 1.3.0'
gem 'unicorn'

group :test, :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'timecop'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'poltergeist'
  gem 'rspec-collection_matchers'
  gem 'site_prism'
  gem 'vcr'
  gem 'webmock'
end
