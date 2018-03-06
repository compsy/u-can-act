# frozen_string_literal: true

class CleanupInvitationTokens
  class << self
    def run
      # Since we're modifying the object, find_each would probably not work.
      # find_each isn't needed, since the scope should always be sufficiently small.
      InvitationToken.all.each do |invitation_token|
        cleanup_invitation_token(invitation_token)
      end
    end

    private

    def cleanup_invitation_token(invitation_token)
      expires_at = calculate_expires_at(invitation_token)

      if expires_at > Time.zone.now
        invitation_token.expires_at = expires_at
        invitation_token.save!
        return
      end
      invitation_token.destroy
    end

    def calculate_expires_at(invitation_token)
      expires_at = [Time.zone.now, TimeTools.increase_by_duration(invitation_token.created_at,
                                                                  InvitationToken::OPEN_TIME_FOR_INVITATION)].max
      invitation_token.invitation_set.responses.each do |response|
        next if response.completed?
        expires_at = [expires_at, response.expires_at].max
      end
      expires_at
    end
  end
end
