# frozen_string_literal: true

class InvitationMailer < ApplicationMailer
  helper ApplicationHelper

  DEFAULT_INVITATION_SUBJECT = ENV['PROJECT_NAME']
  layout 'mailer'

  default from: ENV['FROM_EMAIL_ADDRESS']

  def invitation_mail(email_address, message, invitation_url, template)
    @invitation_url = invitation_url
    @message = message
    # Use the default template if the given template does not exist.
    template = lookup_context.find_all(template, []).blank? ? 'invitation_mailer/invitation_mail' : template
    mail(subject: DEFAULT_INVITATION_SUBJECT, to: email_address) do |format|
      format.html { render template: template }
    end
  end

  # Only used for u-can-act symposium registration. Remove when removing the u-can-act project.
  def confirmation_mail(email_address, subject, message)
    @message = message
    mail(subject: subject, to: email_address)
  end

  # Only used for the IKIA project for parents to invite children. Remove when removing the ikia project.
  def registration_mail(email_address, message, registration_url)
    @registration_url = registration_url
    @message = message
    mail(subject: Rails.application.config.settings.registration.subject_line, to: email_address)
  end
end
