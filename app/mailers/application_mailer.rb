# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)

  default from: 'from@example.com'
  layout 'mailer'
end
