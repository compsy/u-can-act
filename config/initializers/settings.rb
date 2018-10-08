require 'ostruct'
Rails.application.configure do
  settings = config_for(:settings)

  # Convert the settings to a nested openstruct, which allows us to do
  # Rails.application.config.settings.nested_something.nested_array
  config.settings = JSON.parse(settings.to_json, object_class: OpenStruct)
  config.i18n.load_path += Dir[Rails.root.join('config',
                                               'organizations',
                                               config.settings.application_name,
                                               'locales',
                                               '**',
                                               '*.{rb,yml}').to_s] if config.settings.application_name.present? &&
    Dir.exist?(Rails.root.join('config', 'organizations', config.settings.application_name, 'locales')) &&
    !Rails.env.test?
end
