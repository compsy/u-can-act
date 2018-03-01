# frozen_string_literal: true

# TODO: REMOVE THIS ENTIRE USE CASE (move it to the send_invitation_job.rb)
class SendInvitation < ActiveInteraction::Base
  object :response

  def execute
    # TODO: remove?
    # response.initialize_invitation_token!
    person = response.protocol_subscription.person

    SendSms.run!(send_sms_attributes)
    send_email(person.email, random_message, invitation_url) if person.mentor?
  end

  private


  def generate_sms_message
    "#{random_message} #{invitation_url}"
  end

  # TODO: move to invitation.rb or invitation_token.rb
  def invitation_url
    "#{ENV['HOST_URL']}/?q=#{response.invitation_token.token}"
  end
end
