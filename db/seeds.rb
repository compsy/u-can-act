# frozen_string_literal: true

# Running rake db:reset will leave seeds with a terminated connection.
ActiveRecord::Base.connection.reconnect! if Rails.env.development?

if Rails.env.development?
  Person.destroy_all
end

# Load only top level seeds file from evaluatieonderzoek and demo
seed_directory = ENV['PROJECT_NAME']
raise 'Seeds directory cannot be nil!' unless ENV['PROJECT_NAME']

puts "Loading seeds for #{seed_directory}"
Dir[File.join(Rails.root, 'projects', seed_directory, 'seeds', '*.rb')].each do |file|
  require file
end

# Remember to use create!/save! instead of create/save everywhere in seeds
puts 'Seeds loaded!'
