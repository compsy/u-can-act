# Can move this to config/environments/production.rb (and staging.rb) if we only want lograge in production/staging
Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.base_controller_class = 'ApplicationController'
  # In some test specs, where we test JWT login without specifying a token,
  # current_user raises an error, hence this fallback.
  config.lograge.custom_payload do |controller|
    begin
      {
        user_id: controller.current_user.try(:id)
      }
    rescue OpenSSL::PKey::RSAError
      {
      }
    end
  end
  config.lograge.custom_options = lambda do |event|
    exceptions = %w[controller action format id]
    {
      time: event.time,
      params: event.payload[:params].except(*exceptions)
    }
  end
end
