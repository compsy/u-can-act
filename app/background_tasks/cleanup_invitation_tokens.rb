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
      expires_at = invitation_token.calculate_expires_at
      if expires_at > Time.zone.now
        invitation_token.expires_at = expires_at
        invitation_token.save!
        return
      end
      invitation_token.destroy
    end
  end
end
