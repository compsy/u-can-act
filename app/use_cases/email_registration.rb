# frozen_string_literal: true

class EmailRegistration < ActiveInteraction::Base
  object :person

  # Sends a person a registration email
  #
  # Params:
  # - person: the person to send the email to
  def execute
    target_audience = person.role.title
    registration_url = "#{Rails.application.config.settings.registration.url}?targetAudience=#{target_audience}"
    mailer = InvitationMailer.registration_mail(person.email,
                                                Rails.application.config.settings.registration.text,
                                                registration_url)
    mailer.deliver_now
  end
end
