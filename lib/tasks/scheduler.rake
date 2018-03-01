# frozen_string_literal: true

namespace :scheduler do
  desc 'Send invitations'
  task send_invitations: :environment do
    # TODO: fix below comment
    # Run every 15 minutes (max: 2.hours (see RECENT_PAST in Response model))
    puts 'Sending invitations - started'
    SendInvitations.run
    puts 'Sending invitations - done'
  end

  desc 'Set protocol subscriptions to completed'
  task complete_protocol_subscriptions: :environment do
    # Run daily (e.g., at 3am).
    puts 'Setting protocol subscriptions to completed - started'
    CompleteProtocolSubscriptions.run
    puts 'Setting protocol subscriptions to completed - done'
  end

  desc 'Destroy stale invitation tokens'
  task cleanup_invitation_tokens: :environment do
    # Run daily (e.g., at 4am).
    puts 'Destroying stale invitation tokens - started'
    CleanupInvitationTokens.run
    puts 'Destroying stale invitation tokens - done'
  end
end
