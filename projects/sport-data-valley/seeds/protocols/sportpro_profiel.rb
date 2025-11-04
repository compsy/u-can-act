# frozen_string_literal: true

# SportPro Profile Protocol

default_protocol_duration = 4.weeks   
default_open_duration = 4.weeks      

pr_name = 'sportpro_profiel'
protocol = Protocol.find_by(name: pr_name)
protocol ||= Protocol.new(name: pr_name)
protocol.duration = default_protocol_duration
protocol.save!

bp_name = 'base-platform-subscription-sportpro-profiel'
bp_push_subscription = protocol.push_subscriptions.find_by(name: bp_name)
bp_push_subscription ||= protocol.push_subscriptions.build(name: bp_name)
bp_push_subscription.method = 'POST'
bp_push_subscription.url = ENV['PUSH_SUBSCRIPTION_URL']
bp_push_subscription.save!

protocol.save!

# Add the one-time profile setup questionnaire
profile_questionnaire_name = 'SportPro Profiel'
profile_questionnaire = Questionnaire.find_by(name: profile_questionnaire_name)
raise "Cannot find questionnaire: #{profile_questionnaire_name}" unless profile_questionnaire

profile_questionnaire_id = profile_questionnaire.id

profile_measurement = protocol.measurements.find_by(questionnaire_id: profile_questionnaire_id)
profile_measurement ||= protocol.measurements.build(questionnaire_id: profile_questionnaire_id)
profile_measurement.open_from_offset = 2.minutes
profile_measurement.period = nil                     
profile_measurement.open_duration = default_open_duration
profile_measurement.reward_points = 0
profile_measurement.redirect_url = ENV['BASE_PLATFORM_URL']
profile_measurement.stop_measurement = false
profile_measurement.should_invite = true
profile_measurement.save!
