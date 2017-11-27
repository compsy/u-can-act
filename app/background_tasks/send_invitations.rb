# frozen_string_literal: true

class SendInvitations
  class << self
    def run
      send_invitations_for_response_scope(Response.recently_opened_and_not_sent, false)
      send_invitations_for_response_scope(Response.still_open_and_not_completed, true)
    end

    def send_invitations_for_response_scope(response_scope, reminder)
      sending_state = Response::SENDING_STATE
      sent_state = Response::SENT_STATE
      if reminder
        sending_state = Response::SENDING_REMINDER_STATE
        sent_state = Response::REMINDER_SENT_STATE
      end
      mentor_responses = {}
      # Since we're modifying the object, find_each would probably not work.
      # find_each isn't needed, since the scope should always be sufficiently small.
      response_scope.each do |response|
        next if response.expired?
        next unless response.protocol_subscription.active?
        if response.protocol_subscription.for_myself?
          response.update_attributes!(invited_state: sending_state)
          SendInvitationJob.perform_later response
        else
          response.update_attributes!(invited_state: sent_state)
          mentor_responses[response.protocol_subscription.person_id] = response
        end
      end
      queue_mentor_responses(mentor_responses, sending_state)
    end

    def queue_mentor_responses(mentor_responses, sending_state)
      # We collect the responses for the mentor before, and send them only a single text.
      mentor_responses.each_value do |response|
        response.update_attributes!(invited_state: sending_state)
        SendInvitationJob.perform_later response
      end
    end
  end
end
