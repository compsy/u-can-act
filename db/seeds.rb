# frozen_string_literal: true

# Running rake db:reset will leave seeds with a terminated connection.
ActiveRecord::Base.connection.reconnect! if Rails.env.development?

# Require personal question seeds separately because they
# need to already exist when the protocol seeds are loaded, and the
# order is different on production servers.
require File.join(File.dirname(__FILE__),'seeds','questionnaire_seeds.rb')
# Load seeds from the seeds directory.
Dir[File.join(File.dirname(__FILE__),'seeds','*.rb')].each do |file|
  require file
end

puts 'Seeds loaded!'
