# frozen_string_literal: true

if Rake::Task.task_defined?("assets:precompile")
  Rake::Task["assets:precompile"].enhance ["i18n:js:export"]
end
