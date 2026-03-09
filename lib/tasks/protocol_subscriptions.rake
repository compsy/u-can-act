# frozen_string_literal: true

namespace :maintenance do
  desc 'Cancel active subscriptions for target protocols'
  task cancel_target_protocols: :environment do
    target_protocol_names = %w[
      move_mood_motivation
      sportpro_profiel
      sportpro_wekelijks_logboek_protocol
      daily_protocol_rheumatism
    ].freeze
    dry_run = ENV['DRY_RUN'] == 'true'
    puts "Canceling active subscriptions for: #{target_protocol_names.join(', ')}"
    puts "Dry run: #{dry_run}"

    target_protocol_names.each do |protocol_name|
      protocol = Protocol.find_by(name: protocol_name)
      unless protocol
        puts "- #{protocol_name}: protocol not found"
        next
      end

      active_subscriptions = protocol.protocol_subscriptions.active
      active_count = active_subscriptions.count
      puts "- #{protocol_name}: active subscriptions=#{active_count}"
      next if dry_run

      active_subscriptions.find_each(&:cancel!)
      puts "  canceled=#{active_count}"
    end

    puts 'Done.'
  end
end
