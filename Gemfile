# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Specify ruby version for heroku
ruby '2.4.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.2'

# Use Postgres as the database for Active Record
gem 'pg'

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
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Use React for the UI
gem 'react-rails'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks'
#
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

# Driver for the mongo database
gem 'mongoid'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'pry-rails'

gem 'dotenv-rails'

gem 'coveralls', require: false

# Delayed job for delayed calculation
gem 'delayed_job_active_record'

# D3 visualization
gem 'd3-rails'

# Gem for cheaper worker nodes on Heroku
gem 'workless_revived'

# Messagebird SMS
gem 'messagebird-rest', require: 'messagebird'

gem 'active_interaction'
gem 'active_model_serializers'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri

  # Needed for Circleci to pretty format the output
  gem 'guard-rspec'
  gem 'rspec-rails'
  gem 'rspec_junit_formatter'
end

group :test do
  # Code quality monitoring
  gem 'rubocop'

  # Allows jumping back and forth in time
  gem 'timecop'

  # Code coverage reporter
  gem 'simplecov'

  # Used for gem mocking
  gem 'factory_girl_rails'

  # Test which template was rendered
  gem 'rails-controller-testing'

  # Cleans the database after specs
  gem 'database_cleaner'

  # Integration testing
  gem 'capybara'
  gem 'capybara-screenshot'

  # poltergeist for js testing
  gem 'poltergeist'
end

group :production, :staging do
  # JavaScript runtime
  gem 'therubyracer'

  # Required by Delayed Job
  gem 'daemons'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen'
  gem 'web-console'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen'
end

# JS / CSS Frameworks
# gem 'highcharts-rails'
gem 'materialize-sass'
gem 'modernizr-rails'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data'

gem 'rails-i18n'

gem 'appsignal'
gem 'wdm', '>= 0.1.0' if Gem.win_platform?
