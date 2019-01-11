require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Zikaron
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.i18n.default_locale = :he
    config.i18n.available_locales = [:he, :en]
    config.i18n.fallbacks = [:he]

    #config.serve_static_assets = true

    config.filter_parameters += [:password]

    config.active_support.escape_html_entities_in_json = true
  end
end
