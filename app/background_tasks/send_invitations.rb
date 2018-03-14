# frozen_string_literal: true

class SendInvitations
  REMINDER_DELAY = 8.hours

  class << self
    def run
      # Since we're modifying the object, find_each would probably not work.
      # find_each also isn't needed, since the scope should always be sufficiently small.
      response_sets = Hash.new([])
      Response.recently_opened_and_not_invited.each do |response|
        next if response.expired?
        next unless response.protocol_subscription.active?
        person_id = response.protocol_subscription.person_id
        response_sets[person_id] += [response]
      end
      queue_invitation_sets(response_sets)
    end

    private

    def queue_invitation_sets(response_sets)
      response_sets.each do |person_id, responses|
        invitation_set = InvitationSet.create!(person_id: person_id, responses: responses)
        create_invitations(invitation_set)
        SendInvitationsJob.perform_later invitation_set
        SendInvitationsJob.set(wait: REMINDER_DELAY).perform_later invitation_set
      end
    end

    def create_invitations(invitation_set)
      invitation_set.invitations.create!(type: 'EmailInvitation') unless invitation_set.person.email.blank?
      invitation_set.invitations.create!(type: 'SmsInvitation')
    end
  end
end
