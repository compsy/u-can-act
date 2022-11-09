# Don't delay jobs when running this as a service of the base platform locally in development
Delayed::Worker.delay_jobs = false if ENV['RUNNING_AS_SERVICE'].present?

if Rails.env.production? || Rails.env.staging?
  if ENV['PAPERTRAIL_HOST'].present?
    Delayed::Worker.logger = RemoteSyslogLogger.new(ENV['PAPERTRAIL_HOST'],
                                           ENV['PAPERTRAIL_PORT'].to_i,
                                           program: "rails-#{ENV['PAPERTRAIL_PROGRAM']}")
  end
  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    Delayed::Worker.logger = ActiveSupport::TaggedLogging.new(logger)
  end
else
  Delayed::Worker.logger = Logger.new(Rails.root.join('log', 'dj.log'))
end
