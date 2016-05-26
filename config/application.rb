require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'csv'
# require 'iconv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Trackman
  class Application < Rails::Application

    # # Settings for the pool of renderers:
    # config.react.server_renderer_pool_size  ||= 1  # ExecJS doesn't allow more than one on MRI
    # config.react.server_renderer_timeout    ||= 20 # seconds
    # config.react.server_renderer = React::ServerRendering::SprocketsRenderer
    # config.react.server_renderer_options = {
    #     files: ["react-server.js", "components.js"], # files to load for prerendering
    #     replay_console: true,                 # if true, console.* will be replayed client-side
    # }
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Trackmanive Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.react.variant      = :production
    config.react.addons       = true

    config.browserify_rails.source_map_environments << 'development'
    config.browserify_rails.commandline_options = "-t coffee-reactify --extension=\'.cjsx\' --extension=\'.js.coffee\'"

    config.assets.paths << "#{Rails.root}/app/assets/fonts"
    config.assets.precompile += %w( .svg .eot .woff .ttf .otf)

    config.autoload_paths += %W(#{config.root}/app/workers)

  end
end
