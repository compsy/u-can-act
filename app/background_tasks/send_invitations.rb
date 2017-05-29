# frozen_string_literal: true

class SendInvitations
  def self.run
    # Since we're modifying the object, find_each would probably not work.
    # find_each isn't needed, since the scope should always be sufficiently small.
    mentor_responses = {}
    Response.recently_opened_and_not_sent.each do |response|
      next if response.expired?
      next unless response.protocol_subscription.active?
      response.update_attributes!(invited_state: Response::SENDING_STATE)
      if response.protocol_subscription.for_myself?
        SendInvitationJob.perform_later response
      else
        mentor_responses[response.protocol_subscription.person_id] = response
      end
    end

    # We collect the responses for the mentor before, and send them only a single text.
    mentor_responses.each { |_key, response| SendInvitationJob.perform_later response }
  end
end
