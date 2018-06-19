require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
Mongo::Logger.logger.level = ::Logger::INFO

module Vsv
  class Application < Rails::Application

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    Rails.application.routes.default_url_options[:host] = ENV['HOST_URL']

    config.time_zone = 'Amsterdam'

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :nl

    config.autoload_paths += %W(#{config.root}/app/validators)
    config.autoload_paths += %W(#{config.root}/app/background_tasks)
    config.autoload_paths += %W(#{config.root}/app/tools)
    config.autoload_paths += %W(#{config.root}/app/use_cases)
    config.autoload_paths += %W(#{config.root}/app/adapters)
    config.autoload_paths += %W(#{config.root}/app/generators)
    config.autoload_paths += %W(#{config.root}/app/exporters)
    config.autoload_paths += %W(#{config.root}/app/middleware)

    config.active_job.queue_adapter = :delayed_job

    # Enable the asset pipeline
    config.assets.enabled = true

    # Enable react addons
    config.react.addons = true

    config.generators do |g|
      # Set basic DBMS as main database
      g.orm :active_record
      # set rspec as the testframework
      g.test_framework :rspec, fixture: true
      # Define the factories of factory bot (model mock)
      g.fixture_replacement :factory_bot, dir: 'spec/factories'

      # Generate specs for helpers and views
      g.view_specs true
      g.helper_specs true

      # Don't generate stylesheets and javascript
      g.stylesheets = false
      g.javascripts = false
      g.helper = false
    end
  end
end
