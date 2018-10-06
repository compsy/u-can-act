# frozen_string_literal: true

# Running rake db:reset will leave seeds with a terminated connection.
ActiveRecord::Base.connection.reconnect! if Rails.env.development?

if Rails.env.development?
  Person.destroy_all
end

# These seeds need to be loaded first, and in order.
%w[questionnaires protocols organizations teams].each do |seed_directory|
  Dir[File.join(File.dirname(__FILE__), 'seeds', seed_directory, '**', '*.rb')].each do |file|
    require file
  end
end

# Load only top level seeds file from differentiatie_binnenstebuiten
%w[differentiatie_binnenstebuiten].each do |seed_directory|
  Dir[File.join(File.dirname(__FILE__), 'seeds', seed_directory, '*.rb')].each do |file|
    require file
  end
end

# Load only top level seeds file from evaluatieonderzoek
%w[evaluatieonderzoek].each do |seed_directory|
  Dir[File.join(File.dirname(__FILE__), 'seeds', seed_directory, '*.rb')].each do |file|
    require file
  end
end

# Load seeds from the seeds directory.
Dir[File.join(File.dirname(__FILE__), 'seeds', '*.rb')].each do |file|
  require file
end

# Remember to use create!/save! instead of create/save everywhere in seeds

# WARNING: seeds below are not idempotent: use dbsetup after changing something
if Rails.env.development? && ProtocolSubscription.count.zero?
  %w[u-can-act differentiatie].each do |seed_name|
    Dir[File.join(File.dirname(__FILE__), 'seeds', 'test', "#{seed_name}.rb")].each do |file|
      require file
    end
  end
end

puts 'Seeds loaded!'
