# frozen_string_literal: true

namespace :maintenance do
  # Run with
  # be rake "maintenance:echo_people[people.csv]"
  desc 'Echo people from a csv file'
  task :echo_people, [:csv_file] => [:environment] do |_, args|
    puts "Echoing people from '#{args[:csv_file]}' - started"
    EchoPeople.run!(file_name: args[:csv_file])
    puts "Echoing people from '#{args[:csv_file]}' - done"
  end

  desc 'Fixing variables in the Mongo responses'
  task fix_responses: :environment do
    Rails.logger.info 'Fixing responses - started'
    FixResponses.run!
    Rails.logger.info 'Fixing responses - finished'
  end
end
