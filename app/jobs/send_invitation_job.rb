# frozen_string_literal: true

class SendInvitationJob < ApplicationJob
  queue_as :default

  def perform(response)
    SendInvitation.run!(response: response)
    if response.invited_state == Response::SENDING_STATE
      response.update_attributes!(invited_state: Response::SENT_STATE)
    else
      response.update_attributes!(invited_state: Response::REMINDER_SENT_STATE)
    end
  end

  def max_attempts
    2
  end

  def reschedule_at(current_time, _attempts)
    current_time + 1.hour
  end
end
