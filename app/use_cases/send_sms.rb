# frozen_string_literal: true

class SendSms < ActiveInteraction::Base
  string :number
  string :text
  string :reference

  # Function to send SMS text messages with a given text to a given number
  #
  # Params:
  # - number: the mobile number to send the text to
  # - text: the text to send in the sms
  # - reference: extra parameter to identify the text message on messagebird
  def execute
    # It is possible that no Messagebird api key is provided. To
    # ensure they are set in staging and production we raise an error.
    raise 'No Messagebird credentials are provided.' unless credentials_provided?
    raise 'No name to send the message from is provided.' unless messagebird_send_from_provided?

    sms = MessageBirdAdapter.new(Rails.env.test?)
    sms.send_text(ENV['MESSAGEBIRD_SEND_FROM'], number, text, reference: reference)

    # fail DeliveryFailure, response.message unless response.success?
    # Failure detection no longer provided.
  end

  private

  def credentials_provided?
    ENV['MESSAGEBIRD_ACCESS_KEY'].present?
  end

  def messagebird_send_from_provided?
    ENV['MESSAGEBIRD_SEND_FROM'].present?
  end
end
