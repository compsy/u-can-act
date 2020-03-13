# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

ENV['TZ'] = 'Europe/Amsterdam' # Fix for the selenium webbrowser not being in the correct timezone

require 'rspec/rails'
require 'database_cleaner'
require 'database_cleaner/active_record'
require 'database_cleaner/mongoid'
require 'dotenv'
require 'capybara/rspec'
require 'selenium/webdriver'
require 'webdrivers/chromedriver'
require 'capybara-screenshot/rspec'

# Start coverage report on CircleCI
if ENV['CI']
  require 'coveralls'
  Coveralls.wear!
  require 'simplecov'
  SimpleCov.start
end

# Also require the support files for testing
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

# Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
# order to ease the transition to Capybara we set the default here. If you'd
# prefer to use XPath just remove this line and adjust any selectors in your
# steps to use the XPath syntax.

Capybara.default_selector = :css
Capybara.default_max_wait_time = 4
Capybara.ignore_hidden_elements = false

# Uncomment for debugging headless chrome errors:
# Webdrivers.logger.level = :DEBUG
Webdrivers.cache_time = 86_400

Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  [
    'no-sandbox',
    'headless',
    'disable-gpu',
    'disable-infobars',
    'disable-extensions',
    'disable-dev-shm-usage',
    # We need to specify the window size, otherwise it is to small and
    # collapses everything in the admin panel.
    'window-size=1280x1280'
  ].each { |arg| options.add_argument(arg) }
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.javascript_driver = :selenium_chrome_headless
Capybara.default_driver = :rack_test

RSpec.configure do |config|
  config.color_mode = :off if ENV['CI']
  # Include controller helpers for Devise
  # config.include Devise::Test::ControllerHelpers, type: :controller
  # Devise helpers for capybara
  # config.include Warden::Test::Helpers

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # This should be false for selenium / capybara (https://github.com/plataformatec/devise/wiki/How-To:-Test-with-Capybara)
  config.use_transactional_fixtures = false
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # Include controller macros in the controllers (support/controller_macros)
  # config.extend ControllerMacros
  # Includes the formhelpers for features
  # config.include FormHelpers, type: :feature
  config.include UiMacros, type: :feature
  config.include AuthHelper

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # Before and after filters for the rspec runner

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner[:active_record].strategy = :truncation
    DatabaseCleaner[:mongoid].strategy = :truncation
  end

  config.before do
    Timecop.return
    DatabaseCleaner.clean
    ActionMailer::Base.deliveries.clear
    MessageBirdAdapter.deliveries.clear
    ActiveJob::Base.queue_adapter = :delayed_job # other tests may leave a lingering :test here,
    # causing delayed job specs to fail
  end

  config.before(type: :feature) do
    Rails.application.config.action_dispatch.show_exceptions = true
  end

  if ENV['CI']
    config.before(:example, :focus) do
      raise 'This example was committed with `:focus` and should not have been'
    end
  end

  config.after(type: :feature) do
    Rails.application.config.action_dispatch.show_exceptions = false
  end

  config.append_after do
    Capybara.reset_sessions!
    DatabaseCleaner.clean
  end

  config.after(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
end
