# frozen_string_literal: true

class SendInvitation < ActiveInteraction::Base
  object :response

  def execute
    create_invitation_token!
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

  def create_invitation_token!
    # If a token exists for this response, reuse that token (so the old SMS invite link still works
    # when sending a reminder). But still recreate the invitation_token object, so we know that the
    # created_at is always when the object was last used. Also, if we don't first destroy the
    # invitation_token, then it will set a different token than what we're giving (since tokens have
    # to be unique).
    token = response.invitation_token&.token
    response.invitation_token&.destroy
    response.create_invitation_token!(token: token)
  end

  def generate_message
    "#{random_message} #{invitation_url}"
  end

  def random_message
    'Er staat een nieuwe vragenlijst voor je klaar. Vul deze nu in!'
  end

  def invitation_url
    "#{ENV['HOST_URL']}/?q=#{response.invitation_token.token}"
  end

  def generate_reference
    "vsv-#{response.id}"
  end
end
