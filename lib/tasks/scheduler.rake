# frozen_string_literal: true

namespace :scheduler do
  desc 'Send invitations'
  task send_invitations: :environment do
    puts 'Sending invitations - started'
    SendInvitations.run
    puts 'Sending invitations - done'
  end
end
