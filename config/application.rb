require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
Mongo::Logger.logger.level = ::Logger::INFO

module Vsv
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    Rails.application.routes.default_url_options[:host] = ENV['HOST_URL']

    config.time_zone = 'Amsterdam'

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :nl
    config.i18n.available_locales = [:nl, :en]

    # Rails 6 optimization.
    # See https://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#config-add-autoload-paths-to-load-path
    config.add_autoload_paths_to_load_path = false

    config.active_record.yaml_column_permitted_classes = [Symbol, Time, ActiveSupport::TimeWithZone, ActiveSupport::TimeZone]

    config.middleware.use I18n::JS::Middleware

    config.active_job.queue_adapter = :delayed_job

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
