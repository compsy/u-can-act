default_protocol_duration = 1.day
default_open_duration = 30.days

pr_name = 'kccq'
protocol = Protocol.find_by(name: pr_name)
protocol ||= Protocol.new(name: pr_name)
protocol.duration = default_protocol_duration
protocol.save!

bp_name = 'base-platform-subscription-kccq'
bp_push_subscription = protocol.push_subscriptions.find_by(name: bp_name)
bp_push_subscription ||= protocol.push_subscriptions.build(name: bp_name)
bp_push_subscription.method = 'POST'
bp_push_subscription.url = ENV['PUSH_SUBSCRIPTION_URL']
bp_push_subscription.save!

protocol.save!

name = 'kccq'
questionnaire = Questionnaire.find_by(name: name)
raise "Cannot find questionnaire: #{name}" unless questionnaire

questionnaire_id = questionnaire.id

measurement = protocol.measurements.find_by(questionnaire_id: questionnaire_id)
measurement ||= protocol.measurements.build(questionnaire_id: questionnaire_id)
measurement.open_from_offset = 2.minutes
measurement.period = nil
measurement.open_duration = default_open_duration
measurement.reward_points = 0
measurement.redirect_url = ENV['BASE_PLATFORM_URL']
measurement.stop_measurement = false
measurement.should_invite = true
measurement.save!
