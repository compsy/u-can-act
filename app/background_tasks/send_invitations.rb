# frozen_string_literal: true

class SendInvitations
  def self.run
    # Since we're modifying the object, find_each would probably not work.
    # find_each isn't needed, since the scope should always be sufficiently small.
    Response.recently_opened_and_not_sent.each do |response|
      next unless response.protocol_subscription.active?
      next if response.expired?
      response.update_attributes!(invited_state: Response::SENDING_STATE)
      SendInvitationJob.perform_later response
    end
    Response.still_open_and_not_completed.each do |response|
      next unless response.protocol_subscription.active?
      next if response.expired?
      response.update_attributes!(invited_state: Response::SENDING_REMINDER_STATE)
      SendInvitationJob.perform_later response
    end
  end
end
