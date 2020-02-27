# frozen_string_literal: true

namespace :scheduler do
  desc 'Send invitations'
  task send_invitations: :environment do
    # Run every 15 minutes (max: 2.hours (see RECENT_PAST in Response model))
    Rails.logger.info('Sending invitations - started')
    SendInvitations.run
    Rails.logger.info('Sending invitations - done')
  end

  desc 'Run overview cacher'
  task cache_overview: :environment do
    # Run hourly on days where the content could have changed
    Rails.logger.info('Caching overview - started')
    CacheOverview.run
    Rails.logger.info('Caching overview - done')
  end

  desc 'Set protocol subscriptions to completed'
  task complete_protocol_subscriptions: :environment do
    # Run daily (e.g., at 3am).
    Rails.logger.info('Setting protocol subscriptions to completed - started')
    CompleteProtocolSubscriptions.run
    Rails.logger.info('Setting protocol subscriptions to completed - done')
  end

  desc 'Destroy stale invitation tokens'
  task cleanup_invitation_tokens: :environment do
    # Run daily (e.g., at 4am).
    Rails.logger.info('Destroying stale invitation tokens - started')
    CleanupInvitationTokens.run
    Rails.logger.info('Destroying stale invitation tokens - done')
  end

  task monitoring: :environment do
    Rails.logger.info('Monitoring - started')
    SnitchJob.perform_later
    Rails.logger.info('Monitoring - done')
  end

  task rescheduling: :environment do
    Rails.logger.info('Rescheduling - started')
    ReschedulingJob.perform_later
    Rails.logger.info('Rescheduling - done')
  end

  desc 'Calculate distributions for questionnaire responses'
  task calculate_distributions: :environment do
    # Should be called once per day optionally, or not at all,
    # since we update the stats for every questionnaire after filling out a response.
    Rails.logger.info('Calculating distributions - started')
    CalculateDistributionsJob.perform_later
    Rails.logger.info('Calculating distributions - done')
  end

  desc 'Recalculate all scores and distributions'
  task recalculate_questionnaires: :environment do
    # Does not need to be called unless score definitions were updated
    # of a questionnaire that was already filled out by some people.
    Rails.logger.info('Recalculating questionnaires - started')
    Questionnaire.all.each(&:recalculate_scores!)
    Rails.logger.info('Recalculating questionnaires - done')
  end

  desc 'Regenerate questionnaire headers'
  task generate_questionnaire_headers: :environment do
    Rails.logger.info('Generating questionnaire headers - started')
    QuestionnaireHeadersJob.perform_later
    Rails.logger.info('Generating questionnaire headers - done')
  end
end
