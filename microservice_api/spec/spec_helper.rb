# frozen_string_literal: true

require 'rspec'
require 'factory_bot_rails'
require 'compsy-microservice-api'
require 'active_support/core_ext/numeric/time'

# rubocop:disable Style/MixinUsage
include Compsy::MicroserviceApi
include Compsy::MicroserviceApi::Sessions
include Compsy::MicroserviceApi::Models
# rubocop:enable Style/MixinUsage

# It seems sometimes the Rails constant is defined and Rails.root is injected (which is nil at that moment) resulting
# in missing fabricators. Let's just set the path to the current directory to fix this. See:
# https://github.com/paulelliott/fabrication/blob/42db96f11cbf80d22bd9c87dbf6740894c2b2bdc/lib/fabrication/config.rb#L42
Dir[File.join(__dir__, 'support', '*.rb')].each { |f| require f }
Dir[File.join(__dir__, 'factories', '*.rb')].each { |f| require f }

I18n.load_path << Dir[File.join(__dir__, 'support', '*.yml')]

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
