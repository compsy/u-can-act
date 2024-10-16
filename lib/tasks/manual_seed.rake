# frozen_string_literal: true

# This task allows to manually execute a custom seed file. To run the task call `rails db:seed:file_name` where
# file_name is that of the seed you want to execute (without the extension)
return unless ENV['PROJECT_NAME'].present?

namespace :db do
  namespace :seed do
    Rails.root.glob("projects/#{ENV.fetch('PROJECT_NAME', nil)}/manual_seeds/*.rb").each do |filename|
      task_name = File.basename(filename, '.rb')
      desc "Seed #{task_name}, based on the file with the same name in `db/seeds/*.rb`"
      task task_name.to_sym => :environment do
        load(filename) if File.exist?(filename)
      end
    end
  end
end
