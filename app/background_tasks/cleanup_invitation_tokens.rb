# frozen_string_literal: true

class CleanupInvitationTokens
  # Make it so that we only clean up invitation tokens if
  # they've been expired for 6 months. That way, if someone clicks a (less than six months old)
  # recent link for a questionnaire that has expired, they don't get a "you are not allowed to
  # see this questionnaire", but they'll see a "this questionnaire has expired" message instead.
  # This number cannot be defined in .months because then it changes the time.
  EXPIRATION_GRACE_PERIOD = (6 * 4).weeks

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
      if TimeTools.increase_by_duration(expires_at, EXPIRATION_GRACE_PERIOD) > Time.zone.now
        invitation_token.expires_at = expires_at
        invitation_token.save!
        return
      end
      invitation_token.destroy
    end
  end
end
