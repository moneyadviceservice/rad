source 'https://rubygems.org'

ruby '2.1.5'

# RULES OF THE GEMFILE
#
# 1. Consult contributors before adding a dependency
# 2. Keep dependencies ordered alphabetically
# 3. Place dependencies in the group they belong
# 4. Only use version specifiers where appropriate

gem 'rails', '4.1.8'

gem 'bowndler', github: 'moneyadviceservice/bowndler'
gem 'dough-ruby',
  github: 'moneyadviceservice/dough',
  require: 'dough',
  ref: 'a0a625f'
gem 'pg'
gem 'sidekiq'
gem 'uglifier', '>= 1.3.0'

group :assets do
  gem 'coffee-rails', '~> 4.0.0'
  gem 'jquery-rails'
  gem 'sass-rails', '~> 4.0.4'
end

group :test, :development do
  gem 'factory_girl_rails'
  gem 'pry-rails'
end

group :test do
  gem 'capybara'
  gem 'launchy'
  gem 'rspec-rails'
  gem 'site_prism'
end
