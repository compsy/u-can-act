Rails.application.config.after_initialize do
  Delayed::Job.scaler = :null if ENV['WORKLESS_DISABLED'] == 'true'
end
