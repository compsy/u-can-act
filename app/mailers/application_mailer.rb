# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  helper ApplicationHelper

  # If a template or layout exists in the project directory, prefer it over the default.
  # This works fine even when the views subdirectory does not exist.
  # (Rails won't complain. It is used to having lots of paths in its search space that don't exist.)
  prepend_view_path(Rails.root.join('projects', ENV['PROJECT_NAME'], 'views'))

  default from: 'from@example.com'
  layout 'mailer'
end
