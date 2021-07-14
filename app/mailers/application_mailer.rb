# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  helper ApplicationHelper

  default from: 'from@example.com'
  layout 'mailer'
end
