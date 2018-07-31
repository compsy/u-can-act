# frozen_string_literal: true

require File.expand_path('lib/compsy/microservice_api/version', __dir__)

Gem::Specification.new do |gem|
  gem.name          = 'compsy-microservice-api'
  gem.version       = Compsy::MicroserviceApi::VERSION
  gem.summary       = "API wrapper gem around a microservice's API"
  gem.description   = 'Provides authenticated access to a microservice backend utilities'
  gem.license       = 'MIT'
  gem.authors       = ['Frank Blaauw', 'Ando Emerencia']
  gem.email         = 'microservice@compsy.nl'
  gem.homepage      = 'https://github.com/compsy/vsv/blob/master/microservice_api/README.md'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'active_interaction',   '~> 3.6'
  gem.add_dependency 'httparty',             '~> 0.16'
  gem.add_dependency 'virtus',               '~> 1.0'

  gem.add_development_dependency 'appraisal',         '~> 2.2'
  gem.add_development_dependency 'bundler',           '~> 1.16'
  gem.add_development_dependency 'factory_bot_rails', '~> 4.10'
  gem.add_development_dependency 'rake',              '~> 10.5'
  gem.add_development_dependency 'rspec',             '~> 3.0'
end
