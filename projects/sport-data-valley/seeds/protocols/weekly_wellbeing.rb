default_protocol_duration = 30.weeks # evt eerder dynamisch afbreken

pr_name = 'weekly_wellbeing'
protocol = Protocol.find_by(name: pr_name)
protocol ||= Protocol.new(name: pr_name)

protocol.duration = default_protocol_duration
protocol.informed_consent_questionnaire = nil
protocol.invitation_text = 'Je bent uitgenodigd door je coach om een vragenlijst in te vullen.'
protocol.save!

bp_name = 'base-platform-subscription-weekly-wellbeing'
bp_push_subscription = protocol.push_subscriptions.find_by(name: bp_name)
bp_push_subscription ||= protocol.push_subscriptions.build(name: bp_name)
bp_push_subscription.method = 'POST'
bp_push_subscription.url = ENV['PUSH_SUBSCRIPTION_URL']
bp_push_subscription.save!

protocol.save!

name = 'weekly_wellbeing'
weekly_wellbeing_qid = Questionnaire.find_by(name: name)&.id
raise "Cannot find questionnaire: #{name}" unless weekly_wellbeing_qid

db_measurement = protocol.measurements.where(questionnaire_id: weekly_wellbeing_qid).first
db_measurement ||= protocol.measurements.build(questionnaire_id: weekly_wellbeing_qid)
db_measurement.period = 1.week
db_measurement.open_duration = 1.day
db_measurement.open_from_offset = 7.hours # Only needed when we also specify the open_from_day.
db_measurement.open_from_day = 'monday'
db_measurement.reward_points = 0
db_measurement.stop_measurement = false
db_measurement.should_invite = true
db_measurement.reminder_delay = 9.hours
db_measurement.redirect_url = ENV['BASE_PLATFORM_URL']
db_measurement.only_redirect_if_nothing_else_ready = true
db_measurement.save!
