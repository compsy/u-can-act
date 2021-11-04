# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules').to_s

if ENV['PROJECT_NAME'].nil?
  raise "\n
  You need to define the project name before you can start
  Setup your project as follows: 
  - Create a .env.local and add a PROJECT_NAME ENV var there, containing the name of your project.
  - Create a folder in /projects/<PROJECT_NAME> and add the correct subfolders (look at the demo project for an example)\n
  "
end

asset_directories = %w(images stylesheets)
asset_directories.each do |folder|
  directory = Rails.root.join('projects', ENV['PROJECT_NAME'], 'assets', folder)
  files = Dir.entries(directory)
  next if files.nil?

  # Dir.entries also adds the . and .. folders. Delete them here.
  files.delete('.')
  files.delete('..')

  Rails.application.config.assets.paths << directory.to_s
  Rails.application.config.assets.precompile += files
end

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )

# Add node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join("node_modules")
