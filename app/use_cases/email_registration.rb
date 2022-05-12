# frozen_string_literal: true

require 'addressable/uri'

class EmailRegistration < ActiveInteraction::Base
  object :person

  # Sends a person a registration email
  #
  # Params:
  # - person: the person to send the email to
  def execute
    registration_url = "#{ENV.fetch('REGISTRATION_URL', nil)}?#{query_params}"
    mailer = InvitationMailer.registration_mail(person.email,
                                                Rails.application.config.settings.registration.text,
                                                registration_url)
    mailer.deliver_now
  end

  private

  def query_params
    params_arr = %i[target_audience email]
    shared_secret = ENV.fetch('SHARED_SECRET', nil)
    params_hsh = { target_audience: person.role.title, email: person.email }
    uri = Addressable::URI.new
    uri.query_values = ParameterHasher.generate_hmac_params(params_arr, params_hsh, shared_secret)
    uri.query
  end
end
