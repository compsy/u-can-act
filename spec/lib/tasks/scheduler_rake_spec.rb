# frozen_string_literal: true

require 'rails_helper'

describe 'rake scheduler:send_invitations', type: :task do
  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'calls the send invitations background task' do
    expect(Rails.logger).to receive(:info).once.ordered.with('Sending invitations - started')
    expect(SendInvitations).to receive(:run)
    expect(Rails.logger).to receive(:info).once.ordered.with('Sending invitations - done')
    task.execute
  end
end

describe 'rake scheduler:complete_protocol_subscriptions', type: :task do
  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'calls the complete protocol subscriptions background task' do
    expect(Rails.logger).to receive(:info).once.ordered.with('Setting protocol subscriptions to completed - started')
    expect(CompleteProtocolSubscriptions).to receive(:run)
    expect(Rails.logger).to receive(:info).once.ordered.with('Setting protocol subscriptions to completed - done')
    task.execute
  end
end

describe 'rake scheduler:cleanup_invitation_tokens', type: :task do
  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'calls the cleanup invitation tokens background task' do
    expect(Rails.logger).to receive(:info).once.ordered.with('Destroying stale invitation tokens - started')
    expect(CleanupInvitationTokens).to receive(:run)
    expect(Rails.logger).to receive(:info).once.ordered.with('Destroying stale invitation tokens - done')
    task.execute
  end
end

describe 'rake scheduler:cache_overview', type: :task do
  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'calls the complete cache overview background task' do
    expect(Rails.logger).to receive(:info).once.ordered.with('Caching overview - started')
    expect(CacheOverview).to receive(:run)
    expect(Rails.logger).to receive(:info).once.ordered.with('Caching overview - done')
    task.execute
  end
end

describe 'rake scheduler:monitoring', type: :task do
  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'calls the snitchjob' do
    expect(Rails.logger).to receive(:info).once.ordered.with('Monitoring - started')
    expect(SnitchJob).to receive(:perform_later)
    expect(Rails.logger).to receive(:info).once.ordered.with('Monitoring - done')
    task.execute
  end
end

describe 'rake scheduler:rescheduling', type: :task do
  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'calls the rescheduling job' do
    expect(Rails.logger).to receive(:info).once.ordered.with('Rescheduling - started')
    expect(ReschedulingJob).to receive(:perform_later)
    expect(Rails.logger).to receive(:info).once.ordered.with('Rescheduling - done')
    task.execute
  end
end

describe 'rake scheduler:generate_questionnaire_headers', type: :task do
  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'calls the rescheduling job' do
    expect(Rails.logger).to receive(:info).once.ordered.with('Generating questionnaire headers - started')
    expect(QuestionnaireHeadersJob).to receive(:perform_later)
    expect(Rails.logger).to receive(:info).once.ordered.with('Generating questionnaire headers - done')
    task.execute
  end
end

describe 'rake scheduler:calculate_distributions', type: :task do
  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'calls the rescheduling job' do
    expect(Rails.logger).to receive(:info).once.ordered.with('Calculating distributions - started')
    expect(CalculateDistributionsJob).to receive(:perform_later)
    expect(Rails.logger).to receive(:info).once.ordered.with('Calculating distributions - done')
    task.execute
  end
end

describe 'rake scheduler:recalculate_questionnaires', type: :task do
  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'calls the rescheduling job' do
    FactoryBot.create(:questionnaire)
    expect(Rails.logger).to receive(:info).once.ordered.with('Recalculating questionnaires - started')
    expect_any_instance_of(Questionnaire).to receive(:recalculate_scores!)
    expect(Rails.logger).to receive(:info).once.ordered.with('Recalculating questionnaires - done')
    task.execute
  end
end
