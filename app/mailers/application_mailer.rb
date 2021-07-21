# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  helper ApplicationHelper

  # Make it so that we can also find non-default layouts that exist
  # in the project directories
  prepend_view_path(Rails.root.join('projects', ENV['PROJECT_NAME'], 'views'))

  default from: 'from@example.com'
  layout 'mailer'
end
