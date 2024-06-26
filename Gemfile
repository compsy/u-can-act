# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify ruby version for heroku
ruby '3.2.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.4'

# Use Postgres as the database for Active Record
gem 'pg'

# Driver for Redis datastore
# NOTE: we can upgrade to v5, but then authentication fails with redis
# labs, we need to fix that first.
gem 'redis', '~> 4.7'

# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use HAML for templates
gem 'haml-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Use React for the UI
gem 'react-rails'
gem 'react-source'

# Use highcharts
gem 'highcharts-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

# Driver for the mongo database
gem 'mongoid'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
gem 'redis-mutex'

# Use ActiveModel has_secure_password
gem 'bcrypt'

# Required by Ruby 3.1, fixed in Rails >= 7.0.1 (then the below three are no longer required)
gem 'net-imap', require: false
gem 'net-pop', require: false
gem 'net-smtp', require: false

# Enable cross origin requests
gem 'rack-cors'

gem 'pry-rails'

gem 'dotenv-rails'

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
gem 'active_model_serializers'

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
gem 'rswag-api'
gem 'rswag-ui'

# Custom message for u-can-feel
gem 'ucf_messages'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  # Swagger
  gem 'rswag-specs'

  # Needed for Circleci to pretty format the output
  gem 'guard-rspec'
  gem 'rspec_junit_formatter'
  gem 'rspec-rails'

  # rubymine debugger
  # I disabled it for now because it was giving errors with Ruby 3.1
  # gem 'debase', github: 'ruby-debug/debase', tag: 'v0.2.5.beta2'
  # gem 'ruby-debug-ide'
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
  gem 'simplecov-lcov', require: false

  # Used for gem mocking
  gem 'factory_bot_rails'

  # Test which template was rendered
  gem 'rails-controller-testing'

  # Cleans the database after specs
  gem 'database_cleaner'
  gem 'database_cleaner-active_record'
  gem 'database_cleaner-mongoid'

  # Integration testing
  gem 'capybara'
  gem 'capybara-screenshot'

  # selenium for js testing
  gem 'selenium-webdriver'
  gem 'webdrivers', '=5.3.1'
end

group :production, :staging do
  # See https://github.com/rails/execjs#readme for more supported runtimes
  # See https://github.com/rubyjs/mini_racer/issues/300 for why we need this version
  gem 'mini_racer', '=0.9.0', platforms: :ruby

  # Required by Delayed Job
  gem 'daemons'
end

gem 'addressable'

gem 'workless', git: 'https://github.com/compsy/workless.git', branch: 'fixes'

group :development do
  gem 'server_timing'

  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen'
  gem 'web-console'

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
# Materialize documentation at https://materializecss.github.io/materialize/
gem 'materialize-sass'
gem 'modernizr-rails'

gem 'webpacker', '>=6.0.0.rc.5'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data'

# TODO: do this: https://github.com/fnando/i18n-js/blob/main/MIGRATING_FROM_V3_TO_V4.md
gem 'i18n-js', '=3.9.2' # We still need this gem because it generates translations.js for us.
gem 'rails-i18n'

gem 'lograge'
gem 'remote_syslog_logger'

gem 'appsignal', platforms: :ruby # Fixes an error when installing native extensions for the Appsignal gem.

# push subscriptions
gem 'httparty'
gem 'warden-jwt_auth'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false
