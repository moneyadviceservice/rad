source 'https://rubygems.org'

ruby '2.2.0'

# RULES OF THE GEMFILE
#
# 1. Consult contributors before adding a dependency
# 2. Keep dependencies ordered alphabetically
# 3. Place dependencies in the group they belong
# 4. Only use version specifiers where appropriate

gem 'rails', '4.2.0'

gem 'bowndler', github: 'moneyadviceservice/bowndler'
gem 'dough-ruby',
  github: 'moneyadviceservice/dough',
  require: 'dough',
  ref: 'cf08913'
gem 'letter_opener', group: :development
gem 'pg'
gem 'rollbar'
gem 'sidekiq'
gem 'uglifier', '>= 1.3.0'

group :assets do
  gem 'coffee-rails'
  gem 'jquery-rails'
  gem 'sass-rails'
end

group :test, :development do
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'pry-rails'
  gem 'timecop'
  gem 'guard'
  gem 'guard-livereload', require: false
  gem "rack-livereload"
  gem 'guard-bundler', require: false
  gem 'guard-rails'
  gem 'guard-rspec', require: false
end

group :test do
  gem 'capybara'
  gem 'launchy'
  gem 'rspec-rails'
  gem 'site_prism'
end
