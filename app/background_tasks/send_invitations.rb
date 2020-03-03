# frozen_string_literal: true

class SendInvitations
  class << self
    def run
      # Since we're modifying the object, find_each would probably not work.
      # find_each also isn't needed, since the scope should always be sufficiently small.
      response_sets = Hash.new([])
      Response.recently_opened_and_not_invited.each do |response|
        next if response.expired?
        next unless response.measurement.should_invite?
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

        schedule_invite(invitation_set)
        schedule_reminder(invitation_set)
      end
    end

    def schedule_invite(invitation_set)
      SendInvitationsJob.perform_later invitation_set
    end

    def schedule_reminder(invitation_set)
      reminder_delay = invitation_set.reminder_delay
      return if reminder_delay.blank? || reminder_delay.zero?

      SendInvitationsJob.set(wait: reminder_delay).perform_later invitation_set
    end

    def create_invitations(invitation_set)
      if invitation_set.person.mobile_phone.present?
        invitation_set.invitations.create!(type: 'SmsInvitation')
      elsif invitation_set.person.email.present?
        invitation_set.invitations.create!(type: 'EmailInvitation')
      end
    end
  end
end
