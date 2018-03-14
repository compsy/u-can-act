# frozen_string_literal: true

class SendInvitationJob < ApplicationJob
  queue_as :default

  def perform(invitation, plain_text_token)
    invitation.reload
    invitation.send_invite(plain_text_token)
    invitation.sent!
  end

  def max_attempts
    2
  end

  def reschedule_at(current_time, _attempts)
    current_time + 1.hour
  end
end
