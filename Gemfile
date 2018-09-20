# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Specify ruby version for heroku
ruby '2.4.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.2'

# Use Postgres as the database for Active Record
gem 'pg', '= 0.20.0'

# Driver for Redis datastore
gem 'redis'

# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use HAML for templates
gem 'haml-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Use React for the UI
gem 'react-rails', '= 1.6.2'
gem 'react-source'

# Use highcharts
gem 'highcharts-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

# Driver for the mongo database
gem 'mongoid'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'

# Use ActiveModel has_secure_password
gem 'bcrypt'

# Enable cross origin requests
gem 'rack-cors'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'pry-rails'

gem 'dotenv-rails'

gem 'coveralls', '>= 0.8.21', require: false

# Delayed job for delayed calculation
gem 'delayed_job_active_record'

# D3 visualization
# Version is fixed because the radial progress plot does not yet support newer versions
gem 'animate-rails', github: 'camelmasa/animate-rails'
gem 'd3-rails', '~> 3.5.16'

# Messagebird SMS
gem 'messagebird-rest', require: 'messagebird'

# Email via mailgun
gem 'mailgun-ruby'

gem 'active_interaction'
gem 'active_model_serializers'

# Gem for JWT / Authentication
gem 'jwt'
gem 'knock'

# Gem for authorization
# Using the 3.0 version because of this: https://github.com/CanCanCommunity/cancancan/pull/474
gem 'cancancan', github: 'CanCanCommunity/cancancan', ref: '6e782102f5dfef4bd3cc3feadc49802ea942c234'

# Gem for calling deadmanssnitch
gem 'snitcher'

# Gem for checking iban bank accounts
gem 'iban-tools'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri

  # Needed for Circleci to pretty format the output
  gem 'guard-rspec'
  gem 'rspec-rails'
  gem 'rspec_junit_formatter'
  gem 'teaspoon-jasmine'
end

group :test do
  # Code quality monitoring
  gem 'rubocop'
  gem 'rubocop-rspec'

  # Allows jumping back and forth in time
  gem 'timecop'

  # Code coverage reporter
  gem 'simplecov'

  # Used for gem mocking
  gem 'factory_bot_rails'

  # Test which template was rendered
  gem 'rails-controller-testing'

  # Cleans the database after specs
  gem 'database_cleaner'

  # Integration testing
  gem 'capybara'
  gem 'capybara-screenshot'

  # selenium for js testing
  gem 'capybara-selenium'
  gem 'chromedriver-helper'
  gem 'selenium-webdriver'
end

group :production, :staging do
  # JavaScript runtime
  # gem 'therubyracer'
  # ExecJS::RubyRacerRuntime is not supported. Please replace therubyracer with mini_racer in your Gemfile.
  gem 'mini_racer'

  # Required by Delayed Job
  gem 'daemons'

  # Gem for cheaper worker nodes on Heroku
  # gem 'workless' # disable until this is fixed: https://github.com/lostboy/workless/issues/106#issuecomment-356636649
  # This is quoted as a possible fix: https://github.com/lostboy/workless/pull/107
end

gem 'workless', git: 'https://github.com/patricklindsay/workless.git', branch: 'fixes'

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen'
  gem 'web-console'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-commands-teaspoon'
  gem 'spring-watcher-listen'
end

# Silence noisy requests like /status
gem 'silencer'

# JS / CSS Frameworks
# gem 'highcharts-rails'
gem 'materialize-sass', '>= 1.0.0.rc2'
gem 'modernizr-rails'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data'

gem 'rails-i18n'

gem 'lograge'

gem 'appsignal'
gem 'wdm', '>= 0.1.0' if Gem.win_platform?
