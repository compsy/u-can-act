# frozen_string_literal: true

# TODO: REMOVE THIS ENTIRE USE CASE (move it to the send_invitation_job.rb)
class SendInvitation < ActiveInteraction::Base
  object :response

  def execute
    # TODO: move to invitation_set?!?!??!
    response.initialize_invitation_token!
    person = response.protocol_subscription.person

    SendSms.run!(send_sms_attributes)
    send_email(person.email, random_message, response.invitation_url) if person.mentor?
  end

  private

  def generate_sms_message
    "#{random_message} #{response.invitation_url}"
  end
end
