# Don't delay jobs when running this as a service of the base platform locally in development
Delayed::Worker.delay_jobs = false if ENV['RUNNING_AS_SERVICE'].present?
