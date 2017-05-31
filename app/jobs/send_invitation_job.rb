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
end
