# frozen_string_literal: true

require 'rails_helper'

describe 'rake scheduler:send_invitations', type: :task do
  it 'should preload the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'should run gracefully without protocols or responses' do
    expect do
      expect { task.execute }.to output("Sending invitations - started\nSending invitations - done\n").to_stdout
    end.not_to(raise_error)
  end

  it 'should call the send invitations background task' do
    expect(SendInvitations).to receive(:run)
    expect { task.execute }.to output("Sending invitations - started\nSending invitations - done\n").to_stdout
  end
end

describe 'rake scheduler:complete_protocol_subscriptions', type: :task, focus: true do
  it 'should preload the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'should run gracefully without protocols or responses' do
    expect do
      expect { task.execute }.to output("Setting protocol subscriptions to completed - started\n" \
                                        "Setting protocol subscriptions to completed - done\n").to_stdout
    end.not_to(raise_error)
  end

  it 'should call the complete protocol subscriptions background task' do
    expect(CompleteProtocolSubscriptions).to receive(:run)
    expect { task.execute }.to output("Setting protocol subscriptions to completed - started\n" \
                                      "Setting protocol subscriptions to completed - done\n").to_stdout
  end
end

describe 'rake scheduler:cleanup_invitation_tokens', type: :task, focus: true do
  it 'should preload the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'should run gracefully without protocols or responses' do
    expect do
      expect { task.execute }.to output("Destroying stale invitation tokens - started\n" \
                                        "Destroying stale invitation tokens - done\n").to_stdout
    end.not_to(raise_error)
  end

  it 'should call the cleanup invitation tokens background task' do
    expect(CleanupInvitationTokens).to receive(:run)
    expect { task.execute }.to output("Destroying stale invitation tokens - started\n" \
                                      "Destroying stale invitation tokens - done\n").to_stdout
  end
end
