require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rad
  class Application < Rails::Application
    config.autoload_paths << Rails.root.join('lib')

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    config.action_mailer.default_options = {
      from: 'RADenquiries@moneyadviceservice.org.uk',
      to: 'RADenquiries@moneyadviceservice.org.uk'
    }
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
