# frozen_string_literal: true

pr_name = 'daily_protocol_rheumatism'
protocol = Protocol.find_by(name: pr_name)
protocol ||= Protocol.new(name: pr_name)

protocol.duration = 30.days
protocol.informed_consent_questionnaire = nil
protocol.invitation_text = 'Je bent uitgenodigd om een vragenlijst in te vullen.'
protocol.save!

bp_name = 'base-platform-subscription-daily-protocol-rheumatism'
bp_push_subscription = protocol.push_subscriptions.find_by(name: bp_name)
bp_push_subscription ||= protocol.push_subscriptions.build(name: bp_name)
bp_push_subscription.method = 'POST'
bp_push_subscription.url = ENV['PUSH_SUBSCRIPTION_URL']
bp_push_subscription.save!

protocol.save!

questionnaire_key = 'daily_questionnaire_rheumatism'
questionnaire_id = Questionnaire.find_by(key: questionnaire_key)&.id
raise "Cannot find questionnaire: #{questionnaire_key}" unless questionnaire_id

daily_measurement = protocol.measurements.find_by(questionnaire_id: questionnaire_id)
daily_measurement ||= protocol.measurements.build(questionnaire_id: questionnaire_id)
daily_measurement.open_from_offset = 0 # open right away
daily_measurement.period = 1.day # day
daily_measurement.open_duration = 1.days # Open for one day
daily_measurement.reward_points = 0
daily_measurement.should_invite = true # send invitations
daily_measurement.reminder_delay = 3.hours # default is 19:00, so this would be reminder at 10pm
daily_measurement.redirect_url = ENV['BASE_PLATFORM_URL']
daily_measurement.only_redirect_if_nothing_else_ready = true
daily_measurement.save!
