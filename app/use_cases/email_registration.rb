# frozen_string_literal: true

class EmailRegistration < ActiveInteraction::Base
  object :person

  # Sends a person a registration email
  #
  # Params:
  # - person: the person to send the email to
  def execute
    target_audience = person.role.title
    # TODO: URI decode or encode person email
    # TODO: generate hmac with sha256 using SHARED_SECRET var (see ParameterHasher class)
    registration_url = "#{Rails.application.config.settings.registration.url}?targetAudience=#{target_audience}&email=#{person.email}&hmac=#{generate_hmac}"
    mailer = InvitationMailer.registration_mail(person.email,
                                                Rails.application.config.settings.registration.text,
                                                registration_url)
    mailer.deliver_now
  end

  private

  def generate_hmac
    # TODO: send target
    ''
  end
end
