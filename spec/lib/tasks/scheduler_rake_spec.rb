# frozen_string_literal: true

require 'rails_helper'

describe 'rake scheduler:send_invitations', type: :task do
  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'runs gracefully without protocols or responses' do
    expect do
      expect { task.execute }.to output("Sending invitations - started\nSending invitations - done\n").to_stdout
    end.not_to(raise_error)
  end

  it 'calls the send invitations background task' do
    expect(SendInvitations).to receive(:run)
    expect { task.execute }.to output("Sending invitations - started\nSending invitations - done\n").to_stdout
  end
end

describe 'rake scheduler:complete_protocol_subscriptions', type: :task do
  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'runs gracefully without protocols or responses' do
    expect do
      expect { task.execute }.to output("Setting protocol subscriptions to completed - started\n" \
                                        "Setting protocol subscriptions to completed - done\n").to_stdout
    end.not_to(raise_error)
  end

  it 'calls the complete protocol subscriptions background task' do
    expect(CompleteProtocolSubscriptions).to receive(:run)
    expect { task.execute }.to output("Setting protocol subscriptions to completed - started\n" \
                                      "Setting protocol subscriptions to completed - done\n").to_stdout
  end
end

describe 'rake scheduler:cleanup_invitation_tokens', type: :task do
  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'runs gracefully without protocols or responses' do
    expect do
      expect { task.execute }.to output("Destroying stale invitation tokens - started\n" \
                                        "Destroying stale invitation tokens - done\n").to_stdout
    end.not_to(raise_error)
  end

  it 'calls the cleanup invitation tokens background task' do
    expect(CleanupInvitationTokens).to receive(:run)
    expect { task.execute }.to output("Destroying stale invitation tokens - started\n" \
                                      "Destroying stale invitation tokens - done\n").to_stdout
  end
end

describe 'rake scheduler:cache_overview', type: :task do
  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'runs gracefully without teams' do
    expect do
      expect { task.execute }.to output("Caching overview - started\n" \
                                        "Caching overview - done\n").to_stdout
    end.not_to(raise_error)
  end

  it 'calls the complete cache overview background task' do
    expect(CacheOverview).to receive(:run)
    expect { task.execute }.to output("Caching overview - started\n" \
                                      "Caching overview - done\n").to_stdout
  end
end

describe 'rake scheduler:monitoring', type: :task do
  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'runs gracefully' do
    expect do
      expect { task.execute }.to output("Monitoring - started\n" \
                                        "Monitoring - done\n").to_stdout
    end.not_to(raise_error)
  end

  it 'calls the snitchjob' do
    expect(SnitchJob).to receive(:perform_later)
    expect { task.execute }.to output("Monitoring - started\n" \
                                      "Monitoring - done\n").to_stdout
  end
end

describe 'rake scheduler:rescheduling', type: :task do
  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'runs gracefully' do
    expect do
      expect { task.execute }.to output("Rescheduling - started\n" \
                                        "Rescheduling - done\n").to_stdout
    end.not_to(raise_error)
  end

  it 'calls the rescheduling job' do
    expect(ReschedulingJob).to receive(:perform_later)
    expect { task.execute }.to output("Rescheduling - started\n" \
                                      "Rescheduling - done\n").to_stdout
  end
end

describe 'rake scheduler:generate_questionnaire_headers', type: :task do
  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'runs gracefully' do
    expect do
      expect { task.execute }.to output("Generating questionnaire headers - started\n" \
                                        "Generating questionnaire headers - done\n").to_stdout
    end.not_to(raise_error)
  end

  it 'calls the rescheduling job' do
    expect(QuestionnaireHeadersJob).to receive(:perform_later)
    expect { task.execute }.to output("Generating questionnaire headers - started\n" \
                                      "Generating questionnaire headers - done\n").to_stdout
  end
end
