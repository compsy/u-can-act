# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Specify ruby version for heroku
ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4', '>= 5.2.4.2'

# Use Postgres as the database for Active Record
gem 'pg', '= 1.1.4'

# Driver for Redis datastore
gem 'redis'

# Use Puma as the app server
gem 'puma', '>= 4.3.2'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6.0.0'
# Use HAML for templates
gem 'haml-rails', '>= 2.0.1'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '>= 4.2.2'

# Use React for the UI
gem 'react-rails', '>= 2.6.1'
gem 'react-source'

# Use highcharts
gem 'highcharts-rails', '>= 6.0.3'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

# Driver for the mongo database
gem 'mongoid'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
gem 'redis-mutex'

# Use ActiveModel has_secure_password
gem 'bcrypt'

# Enable cross origin requests
gem 'rack-cors'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'pry-rails'

gem 'dotenv-rails', '>= 2.7.5'

gem 'coveralls', '>= 0.8.21', require: false

# Delayed job for delayed calculation
gem 'delayed_job_active_record'

# Used to scroll to top
gem 'animate-rails', github: 'camelmasa/animate-rails'

# Messagebird SMS
gem 'messagebird-rest', require: 'messagebird'

# Email via mailgun
gem 'mailgun-ruby'

gem 'active_interaction'
gem 'active_model_serializers', '>= 0.10.10'

# Gem for JWT / Authentication
gem 'jwt'

# current master, using this because the version on rubygems hasn't been updated
gem 'knock', github: 'nsarno/knock', ref: '84d3e54b9a8f1e9701097207a8d3135d5a9e64c1'

# Gem for authorization
# Using the 3.0 version because of this: https://github.com/CanCanCommunity/cancancan/pull/474
gem 'cancancan', github: 'CanCanCommunity/cancancan', ref: '6e782102f5dfef4bd3cc3feadc49802ea942c234'

# Gem for calling deadmanssnitch
gem 'snitcher'

# Gem for checking iban bank accounts
gem 'iban-tools'

# Swagger
gem 'rswag-api', '>= 2.2.0'
gem 'rswag-ui', '>= 2.2.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  # Swagger
  gem 'rswag-specs', '>= 2.2.0'

  # Needed for Circleci to pretty format the output
  gem 'guard-rspec'
  gem 'rspec-rails', '>= 3.9.0'
  gem 'rspec_junit_formatter'
end

group :test do
  # Code quality monitoring
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'

  # Allows jumping back and forth in time
  gem 'timecop'

  # Code coverage reporter
  gem 'simplecov'

  # Used for gem mocking
  gem 'factory_bot_rails', '>= 5.1.1'

  # Test which template was rendered
  gem 'rails-controller-testing', '>= 1.0.4'

  # Cleans the database after specs
  gem 'database_cleaner'
  gem 'database_cleaner-active_record'
  gem 'database_cleaner-mongoid'

  # Integration testing
  gem 'capybara', '>= 3.31.0'
  gem 'capybara-screenshot', '>= 1.0.24'

  # selenium for js testing
  gem 'selenium-webdriver'
  gem 'webdrivers', '>= 4.2.0'
end

group :production, :staging do
  # JavaScript runtime
  # gem 'therubyracer'
  # ExecJS::RubyRacerRuntime is not supported. Please replace therubyracer with mini_racer in your Gemfile.
  gem 'mini_racer'

  # Required by Delayed Job
  gem 'daemons'
end

gem 'addressable'

gem 'workless', git: 'https://github.com/compsy/workless.git', branch: 'fixes'

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.7.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen'
end

# Silence noisy requests like /status
gem 'silencer'

# JS / CSS Frameworks
gem 'materialize-sass', '>= 1.0.0'
gem 'modernizr-rails'

gem 'webpacker', '>= 4.2.2'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data'

gem 'i18n-js' # We still need this gem because it generates translations.js for us.
gem 'rails-i18n', '>= 5.1.3'

gem 'lograge', '>= 0.11.2'
gem 'remote_syslog_logger'

gem 'appsignal'
gem 'wdm', '>= 0.1.0' if Gem.win_platform?

# push subscriptions
gem 'httparty'
gem 'warden-jwt_auth', '>= 0.4.0'
