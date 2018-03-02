# frozen_string_literal: true

class CleanupInvitationTokens
  def self.run
    # Since we're modifying the object, find_each would probably not work.
    # find_each isn't needed, since the scope should always be sufficiently small.
    InvitationToken.all.each do |invitation_token|
      next unless invitation_token.expired?
      invitation_token.destroy
    end
  end
end
