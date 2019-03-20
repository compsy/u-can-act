# frozen_string_literal: true

namespace :deployment do
  # Run with
  # be rake "deployment:create_project[project_name]"
  desc 'Create project'
  task :create_project, [:project_name] => [] do |_, args| # doesn't need environment
    puts "Creating project '#{args[:project_name]}' - started"


    def create_env_local_file
      open(File.join(Rails.root, '.env.local'), 'w') do |f|
       f.puts args[:project_name]
      end
    end


    create_env_local_file

    puts "Creating project '#{args[:project_name]}' - done"
  end
end
