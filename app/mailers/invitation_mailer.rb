# frozen_string_literal: true

class InvitationMailer < ActionMailer::Base
  layout 'mailer'

  default from: ENV['FROM_EMAIL_ADDRESS']

  def invitation_mail(email_address, message, invitation_url)
    @invitation_url = invitation_url
    @message = message
    mail(subject: 'u-can-act vragenlijst onderzoek', to: email_address)
  end
end
