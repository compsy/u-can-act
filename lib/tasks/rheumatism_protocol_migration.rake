# frozen_string_literal: true

namespace :rheumatism do
  LEGACY_ONE_TIME_PROTOCOL = 'rheumatism_one_time'
  STANDALONE_PROTOCOL_TARGETS = %w[
    ases_rheumatism
    braf_rheumatism
    eq5d5l_rheumatism
    hads_rheumatism
  ].freeze

  desc 'Migrate rheumatism_one_time subscriptions into standalone rheumatism protocols'
  task migrate_one_time_protocol_subscriptions: :environment do
    dry_run = ENV.fetch('DRY_RUN', 'true') == 'true'
    cancel_legacy = ENV.fetch('CANCEL_LEGACY', 'true') == 'true'

    legacy_protocol = Protocol.find_by(name: LEGACY_ONE_TIME_PROTOCOL)
    if legacy_protocol.blank?
      puts "Protocol '#{LEGACY_ONE_TIME_PROTOCOL}' not found"
      next
    end

    target_protocols = STANDALONE_PROTOCOL_TARGETS.index_with do |protocol_name|
      Protocol.find_by(name: protocol_name)
    end

    missing_targets = target_protocols.select { |_name, protocol| protocol.blank? }.keys
    if missing_targets.present?
      puts "Missing target protocols: #{missing_targets.join(', ')}"
      puts 'Run project seeds first so standalone rheumatism protocols exist.'
      next
    end

    puts "Migrating subscriptions from '#{LEGACY_ONE_TIME_PROTOCOL}'"
    puts "Dry run: #{dry_run}"
    puts "Cancel legacy active subscriptions: #{cancel_legacy}"

    totals = {
      subscriptions_seen: 0,
      created: 0,
      reused: 0,
      responses_copied: 0,
      responses_skipped: 0,
      legacy_canceled: 0
    }

    legacy_protocol.protocol_subscriptions.find_each do |legacy_subscription|
      totals[:subscriptions_seen] += 1
      puts "Legacy subscription ##{legacy_subscription.id} (state=#{legacy_subscription.state})"

      target_protocols.each do |questionnaire_key, target_protocol|
        legacy_response = response_for_questionnaire(legacy_subscription, questionnaire_key)
        if legacy_response.blank?
          totals[:responses_skipped] += 1
          puts "  - #{questionnaire_key}: no legacy response"
          next
        end

        target_subscription = find_target_subscription(legacy_subscription, target_protocol)
        if target_subscription.present?
          totals[:reused] += 1
          puts "  - #{questionnaire_key}: reusing target subscription ##{target_subscription.id}"
        elsif dry_run
          puts "  - #{questionnaire_key}: would create new target subscription"
          next
        else
          target_subscription = create_target_subscription(legacy_subscription, target_protocol)
          totals[:created] += 1
          puts "  - #{questionnaire_key}: created target subscription ##{target_subscription.id}"
        end

        next if dry_run

        target_response = response_for_questionnaire(target_subscription, questionnaire_key)
        if target_response.blank?
          totals[:responses_skipped] += 1
          puts "  - #{questionnaire_key}: no target response found"
          next
        end

        copy_response_data!(legacy_response, target_response)
        synchronize_subscription_state!(legacy_subscription, target_subscription)
        totals[:responses_copied] += 1
      end

      next unless cancel_legacy && legacy_subscription.active?

      if dry_run
        puts "  - would cancel legacy subscription ##{legacy_subscription.id}"
      else
        legacy_subscription.cancel!
        totals[:legacy_canceled] += 1
        puts "  - canceled legacy subscription ##{legacy_subscription.id}"
      end
    end

    puts 'Migration done'
    puts "Subscriptions scanned: #{totals[:subscriptions_seen]}"
    puts "Target subscriptions created: #{totals[:created]}"
    puts "Target subscriptions reused: #{totals[:reused]}"
    puts "Responses copied: #{totals[:responses_copied]}"
    puts "Responses skipped: #{totals[:responses_skipped]}"
    puts "Legacy subscriptions canceled: #{totals[:legacy_canceled]}"
  end

  def response_for_questionnaire(protocol_subscription, questionnaire_key)
    protocol_subscription.responses
                         .joins(measurement: :questionnaire)
                         .find_by(questionnaires: { key: questionnaire_key })
  end

  def find_target_subscription(legacy_subscription, target_protocol)
    ProtocolSubscription.where(
      protocol: target_protocol,
      person: legacy_subscription.person,
      filling_out_for: legacy_subscription.filling_out_for,
      external_identifier: legacy_subscription.external_identifier,
      start_date: legacy_subscription.start_date
    ).order(:id).first
  end

  def create_target_subscription(legacy_subscription, target_protocol)
    ProtocolSubscription.create!(
      protocol: target_protocol,
      person: legacy_subscription.person,
      filling_out_for: legacy_subscription.filling_out_for,
      state: ProtocolSubscription::ACTIVE_STATE,
      start_date: legacy_subscription.start_date,
      end_date: legacy_subscription.end_date,
      external_identifier: legacy_subscription.external_identifier,
      invitation_text_nl: legacy_subscription.invitation_text_nl,
      invitation_text_en: legacy_subscription.invitation_text_en,
      open_from_day_uses_start_date_offset: legacy_subscription.open_from_day_uses_start_date_offset,
      needs_language_input: legacy_subscription.needs_language_input,
      has_language_input: legacy_subscription.has_language_input
    )
  end

  def copy_response_data!(source_response, target_response)
    if target_response.open_from == source_response.open_from &&
       target_response.completed_at == source_response.completed_at &&
       target_response.content.present? == source_response.content.present?
      return
    end

    target_attributes = {
      open_from: source_response.open_from,
      completed_at: source_response.completed_at,
      filled_out_by: source_response.filled_out_by,
      filled_out_for: source_response.filled_out_for,
      invitation_set: source_response.invitation_set,
      original: source_response.original
    }

    source_content = source_response.remote_content
    if source_content.present?
      copied_content = ResponseContent.create!(
        content: source_content.content,
        scores: source_content.scores
      )
      target_attributes[:content] = copied_content.id.to_s
    else
      target_attributes[:content] = nil
    end

    target_response.update!(target_attributes)
  end

  def synchronize_subscription_state!(legacy_subscription, target_subscription)
    return if legacy_subscription.state == ProtocolSubscription::ACTIVE_STATE

    target_subscription.update!(state: legacy_subscription.state, end_date: legacy_subscription.end_date)
  end
end
