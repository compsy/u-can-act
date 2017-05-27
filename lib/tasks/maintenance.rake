# frozen_string_literal: true

namespace :maintenance do
  # Run with
  # be rake "maintenance:load_people[people.csv]"
  desc 'Load people from a csv file'
  task :load_people, [:csv_file] => [:environment] do |_, args|
    puts "Loading people from '#{args[:csv_file]}' - started"
    LoadPeople.run!(file_name: args[:csv_file])
    puts "Loading people from '#{args[:csv_file]}' - done"
  end
end
