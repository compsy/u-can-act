# frozen_string_literal: true

class InvitationMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)

  DEFAULT_INVITATION_SUBJECT = ENV['PROJECT_NAME']
  layout 'mailer'

  default from: ENV['FROM_EMAIL_ADDRESS']

  def invitation_mail(email_address, message, invitation_url)
    @invitation_url = invitation_url
    @message = message
    mail(subject: DEFAULT_INVITATION_SUBJECT, to: email_address)
  end

  def confirmation_mail(email_address, subject, message)
    @message = message
    mail(subject: subject, to: email_address)
  end
end
