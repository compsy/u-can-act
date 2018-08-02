require 'ostruct'
Rails.application.configure do
  settings = config_for(:settings)

  # Convert the settings to a nested openstruct, which allows us to do
  # Rails.application.config.settings.nested_something.nested_array
  config.settings = JSON.parse(settings.to_json, object_class: OpenStruct)
end
