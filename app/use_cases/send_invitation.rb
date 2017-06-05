# frozen_string_literal: true

class SendInvitation < ActiveInteraction::Base
  object :response

  def execute
    response.initialize_invitation_token!
    SendSms.run!(send_sms_attributes)
  end

  private

  def send_sms_attributes
    {
      number: response.protocol_subscription.person.mobile_phone,
      text: generate_message,
      reference: generate_reference
    }
  end

  def generate_message
    "#{random_message} #{invitation_url}"
  end

  def random_message
    'Bedankt voor je hulp! Er staat een vragenlijst voor je klaar. Vul deze nu in!'
  end

  def invitation_url
    "#{ENV['HOST_URL']}/?q=#{response.invitation_token.token}"
  end

  def generate_reference
    "vsv-#{response.id}"
  end
end
