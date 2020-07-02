Rails.application.config.after_initialize do
  Delayed::Job.scaler = :null unless ENV['WORKLESS_ENABLED'] == 'true'
end
