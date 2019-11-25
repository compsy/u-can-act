# frozen_string_literal: true

class EmailRegistration < ActiveInteraction::Base
  object :person

  # Sends a person a registration email
  #
  # Params:
  # - person: the person to send the email to
  def execute
    mailer = InvitationMailer.registration_mail(person.email,
                                                Rails.application.config.settings.registration.text,
                                                Rails.application.config.settings.registration.url)
    mailer.deliver_now
  end
end
