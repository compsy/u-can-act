# Can move this to config/environments/production.rb (and staging.rb) if we only want lograge in production/staging
Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.base_controller_class = 'ApplicationController'
  config.lograge.custom_payload do |controller|
    {
      ip: controller.request.ip,
      user_id: controller.current_user.try(:id)
    }
  end
  config.lograge.custom_options = lambda do |event|
    exceptions = %w[controller action format id]
    {
      time: event.time,
      params: event.payload[:params].except(*exceptions)
    }
  end
end
