# frozen_string_literal: true

# SportPro Logbook Protocol

default_protocol_duration = 1.weeks   
default_open_duration = 1.weeks       

pr_name = 'sportpro_wekelijks_logboek_protocol'
protocol = Protocol.find_by(name: pr_name)
protocol ||= Protocol.new(name: pr_name)
protocol.duration = default_protocol_duration
protocol.save!

bp_name = 'base-platform-subscription-sportpro-wekelijks-logboek'
bp_push_subscription = protocol.push_subscriptions.find_by(name: bp_name)
bp_push_subscription ||= protocol.push_subscriptions.build(name: bp_name)
bp_push_subscription.method = 'POST'
bp_push_subscription.url = ENV['PUSH_SUBSCRIPTION_URL']
bp_push_subscription.save!

protocol.save!

weekly_questionnaire_name = 'SportPro Wekelijks Logboek'
weekly_questionnaire = Questionnaire.find_by(name: weekly_questionnaire_name)
raise "Cannot find questionnaire: #{weekly_questionnaire_name}" unless weekly_questionnaire

weekly_questionnaire_id = weekly_questionnaire.id

weekly_measurement = protocol.measurements.find_by(questionnaire_id: weekly_questionnaire_id)
weekly_measurement ||= protocol.measurements.build(questionnaire_id: weekly_questionnaire_id)
weekly_measurement.open_from_offset = 1.minute
weekly_measurement.period = nil                       
weekly_measurement.open_duration = default_open_duration    
weekly_measurement.reward_points = 0
weekly_measurement.stop_measurement = false
weekly_measurement.should_invite = true
weekly_measurement.redirect_url = ENV['BASE_PLATFORM_URL']
weekly_measurement.save!

