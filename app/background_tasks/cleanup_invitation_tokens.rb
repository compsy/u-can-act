# frozen_string_literal: true

class CleanupInvitationTokens
  def self.run
    # Since we're modifying the object, find_each would probably not work.
    # find_each isn't needed, since the scope should always be sufficiently small.
    InvitationToken.all.each do |invitation_token|
      expires_at = [Time.zone.now, TimeTools.increase_by_duration(invitation_token.created_at, 7.days)].max
      invitation_token.invitation_set.responses.each do |response|
        next if response.completed?
        response_expires_at = if response.measurement.open_duration.present?
                                TimeTools.increase_by_duration(response.open_from, response.measurement.open_duration)
                              else
                                response.protocol_subscription.end_date
                              end
        expires_at = [expires_at, response_expires_at].max
      end
      if expires_at > Time.zone.now
        invitation_token.expires_at = expires_at
        invitation_token.save!
        next
      end
      invitation_token.destroy
    end
  end
end
