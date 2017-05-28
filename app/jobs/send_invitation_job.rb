# frozen_string_literal: true

class SendInvitationJob < ApplicationJob
  queue_as :default

  def perform(response)
    SendInvitation.run!(response: response)
    response.update_attributes!(invited_state: Response::SENT_STATE)
  end
end
