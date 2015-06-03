source 'https://rubygems.org'

ruby '2.2.2'

# RULES OF THE GEMFILE
#
# 1. Consult contributors before adding a dependency
# 2. Keep dependencies ordered alphabetically
# 3. Place dependencies in the group they belong
# 4. Only use version specifiers where appropriate

gem 'rails', '~> 4.2'

gem 'bootstrap-sass', '~> 3.3.3'
gem 'bowndler', github: 'moneyadviceservice/bowndler'
gem 'devise'
gem 'devise_invitable'
gem 'rails_email_validator'
gem 'devise_security_extension'
gem 'dough-ruby',
    github: 'moneyadviceservice/dough',
    require: 'dough',
    ref: 'cf08913'
gem 'jquery-rails'
gem 'kaminari'
gem 'letter_opener', group: :development
gem 'mas-rad_core', '0.0.53'
gem 'oga'
gem 'pg'
gem 'ransack'
gem 'rollbar'
gem 'sass-rails'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'uglifier', '>= 1.3.0'
gem 'unicorn'

group :test, :development do
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'pry-rails'
  gem 'rubocop'
  gem 'timecop'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'poltergeist'
  gem 'rspec-collection_matchers'
  gem 'rspec-rails'
  gem 'site_prism'
end
