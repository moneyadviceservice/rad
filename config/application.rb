require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rad
  class Application < Rails::Application
    config.load_defaults 5.1

    config.active_record.belongs_to_required_by_default = false

    config.autoload_paths << Rails.root.join('lib')

    config.i18n.load_path += Dir[
      Rails.root.join('config', 'locales', '**', '*.{rb,yml}')
    ]

    config.action_mailer.default_options = {
      from: 'RADenquiries@moneyadviceservice.org.uk',
      to: 'RADenquiries@moneyadviceservice.org.uk'
    }
    # Settings in config/environments/* take precedence over those specified
    # here.  Application configuration should go into files in
    # config/initializers -- all .rb files in that directory are automatically
    # loaded.

    # Switch off sassc concurrency. See this issue
    # https://github.com/rails/sprockets/issues/581#issuecomment-486984663
    config.assets.configure do |env|
      env.export_concurrent = false
    end
  end
end
