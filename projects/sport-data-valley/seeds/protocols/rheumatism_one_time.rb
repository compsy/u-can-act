# frozen_string_literal: true

questionnaire_keys = %w[intake_questionnaire_rheumatism ases_rheumatism braf_rheumatism eq5d5l_rheumatism hads_rheumatism squash]

pr_name = File.basename(__FILE__)[0...-3]
protocol = Protocol.find_by(name: pr_name)
protocol ||= Protocol.new(name: pr_name)

protocol.duration = 1.week
protocol.informed_consent_questionnaire = nil
protocol.invitation_text = 'Je bent uitgenodigd om een vragenlijst in te vullen.'
protocol.save!

bp_name = 'base-platform-subscription-rheumatism-one-time'
bp_push_subscription = protocol.push_subscriptions.find_by(name: bp_name)
bp_push_subscription ||= protocol.push_subscriptions.build(name: bp_name)
bp_push_subscription.method = 'POST'
bp_push_subscription.url = ENV['PUSH_SUBSCRIPTION_URL']
bp_push_subscription.save!

protocol.save!

unused_measurement_ids = protocol.measurements.pluck(:id).to_set
questionnaire_keys.each_with_index do |questionnaire_key, idx|
  questionnaire = Questionnaire.find_by(key: questionnaire_key)
  raise "questionnaire #{questionnaire_key} not found" unless questionnaire

  # Create the measurement for the questionnaire

  questionnaire_id = questionnaire.id
  measurement = protocol.measurements.find_by(questionnaire_id: questionnaire_id)
  measurement ||= protocol.measurements.build(questionnaire_id: questionnaire_id)
  measurement.open_from_offset = 0 # open immediately
  measurement.open_from_day = nil # don't wait for a specific day
  measurement.period = nil # one-off and not repeated
  measurement.open_duration = nil # open for the entire duration of the protocol
  measurement.reminder_delay = 24.hours # send a reminder after 24 hours
  measurement.priority = questionnaire_keys.count - idx # ensure that the questionnaires are shown in the specified order
  measurement.stop_measurement = (questionnaire_key == questionnaire_keys.last) # stop the protocol after filling out
  measurement.should_invite = true # send invitations                    # the last questionnaire
  measurement.redirect_url = ENV['BASE_PLATFORM_URL']
  measurement.only_redirect_if_nothing_else_ready = true
  measurement.save!

  unused_measurement_ids.delete(measurement.id)
end

if unused_measurement_ids.present?
  puts "ERROR: unused measurements present: "
  puts unused_measurement_ids.map do |unused_id|
    Measurement.find(unused_id)&.questionnaire&.key || unused_id.to_s
  end.pretty_inspect
  raise "Error: unused measurement ids present"
end
