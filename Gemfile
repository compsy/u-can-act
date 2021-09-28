# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify ruby version for heroku
ruby '3.0.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.4', '>= 6.1.4.1'

# Use Postgres as the database for Active Record
gem 'pg', '= 1.1.4'

# Driver for Redis datastore
gem 'redis'

# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6.0.0'
# Use HAML for templates
gem 'haml-rails', '>= 2.0.1'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

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

gem 'pry-rails'

gem 'dotenv-rails', '>= 2.7.6'

gem 'coveralls_reborn', require: false

# Delayed job for delayed calculation
gem 'delayed_job_active_record'

# Used to scroll to top
gem 'animate-rails', github: 'camelmasa/animate-rails'

# Messagebird SMS
gem 'messagebird-rest', require: 'messagebird'

# Email via mailgun
gem 'mailgun-ruby'

gem 'active_interaction'
gem 'active_model_serializers', '>= 0.10.12'

# Gem for JWT / Authentication
gem 'jwt'

# current master, using this because the version on rubygems hasn't been updated
gem 'knock', github: 'nsarno/knock', ref: '37e403a7c6d44f585b56a086245e41566a8d6fe1'

# Gem for authorization
# Using the 3.0 version because of this: https://github.com/CanCanCommunity/cancancan/pull/474
gem 'cancancan', github: 'CanCanCommunity/cancancan', ref: '6e782102f5dfef4bd3cc3feadc49802ea942c234'

# Gem for calling deadmanssnitch
gem 'snitcher'

# Gem for checking iban bank accounts
gem 'iban-tools'

# Swagger
gem 'rswag-api', '>= 2.4.0'
gem 'rswag-ui', '>= 2.4.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  # Swagger
  gem 'rswag-specs', '>= 2.4.0'

  # Needed for Circleci to pretty format the output
  gem 'guard-rspec'
  gem 'rspec_junit_formatter'
  gem 'rspec-rails', '>= 5.0.2'

  # rubymine debugger
  gem 'debase', github: 'ruby-debug/debase', tag: 'v0.2.5.beta2'
  gem 'ruby-debug-ide'
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
  gem 'factory_bot_rails', '>= 6.2.0'

  # Test which template was rendered
  gem 'rails-controller-testing', '>= 1.0.5'

  # Cleans the database after specs
  gem 'database_cleaner'
  gem 'database_cleaner-active_record'
  gem 'database_cleaner-mongoid'

  # Integration testing
  gem 'capybara', '>= 3.35.3'
  gem 'capybara-screenshot', '>= 1.0.25'

  # selenium for js testing
  gem 'selenium-webdriver'
  gem 'webdrivers', '>= 4.6.1'
end

group :production, :staging do
  # See https://github.com/rails/execjs#readme for more supported runtimes
  gem 'mini_racer', platforms: :ruby

  # Required by Delayed Job
  gem 'daemons'
end

gem 'addressable'

gem 'workless', git: 'https://github.com/compsy/workless.git', branch: 'fixes'

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen'
  gem 'web-console', '>= 4.1.0'

  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  # gem 'rack-mini-profiler'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen'
end

# Silence noisy requests like /status
gem 'silencer'

# JS / CSS Frameworks
gem 'materialize-sass'
gem 'modernizr-rails'

gem 'webpacker', '>= 5.4.3'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data'

gem 'i18n-js' # We still need this gem because it generates translations.js for us.
gem 'rails-i18n', '>= 6.0.0'

gem 'lograge', '>= 0.11.2'
gem 'remote_syslog_logger'

gem 'appsignal'

# push subscriptions
gem 'httparty'
gem 'warden-jwt_auth'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false
