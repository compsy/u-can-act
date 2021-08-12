# frozen_string_literal: true

namespace :deployment do
  # Run with
  # be rake "deployment:create_project[project_name]"
  # rubocop:disable Rails/RakeEnvironment
  desc 'Create project'
  task :create_project, [:project_name] => [] do |_, args| # doesn't need environment
    @args = args
    puts "Creating project '#{@args[:project_name]}' - started"

    def create_env_local_file
      if File.file?(Rails.root.join('.env.local'))
        puts 'File .env.local already exists'
        return
      end
      puts 'Creating .env.local file...'
      File.open(Rails.root.join('.env.local'), 'w') do |f|
        f.puts "PROJECT_NAME:      #{@args[:project_name]}"
        f.puts ''
        f.puts "HOST_URL:          http://#{@args[:project_name]}.io"
        f.puts "HOST_DOMAIN:       #{@args[:project_name]}.io"
        f.puts "INFO_EMAIL:        info@#{@args[:project_name]}.io"
        f.puts ''
        f.puts "SITE_LOCATION:     http://#{@args[:project_name]}.io"
      end
    end

    def get_relative_filenames(directory)
      Dir.glob(File.join(File.expand_path(directory), '**', '*'))
         .select { |file| File.file?(file) }
         .map { |file| file.sub(File.expand_path(directory), '') }
    end

    def copy_only_nonexisting_files(source_dir, target_dir)
      get_relative_filenames(source_dir).each do |filepath|
        target_file = File.join(target_dir, filepath)
        if File.file?(target_file)
          puts "File #{target_file} already exists"
          next
        end
        puts "Creating #{target_file} file..."
        FileUtils.mkdir_p(File.dirname(target_file))
        FileUtils.cp(File.join(source_dir, filepath), target_file)
      end
    end

    def create_project_directory
      puts "creating projects/#{@args[:project_name]} directory..."
      source_dir = Rails.root.join('projects/new')
      target_dir = Rails.root.join('projects', @args[:project_name])
      copy_only_nonexisting_files(source_dir, target_dir)
    end

    if @args[:project_name].blank?
      puts 'ERROR: syntax: bundle exec rake "deployment:create_project[project_name]"'
      exit(1)
    end

    create_env_local_file
    create_project_directory

    puts "Creating project '#{@args[:project_name]}' - done"
    puts "\nYou should now type:\nbundle exec rake db:setup"
  end
  # rubocop:enable Rails/RakeEnvironment
end
