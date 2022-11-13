default_protocol_duration = 1.day  # evt eerder dynamisch afbreken

pr_name = 'psychological_competencies'
protocol = Protocol.find_by(name: pr_name)
protocol ||= Protocol.new(name: pr_name)

protocol.duration = default_protocol_duration
protocol.informed_consent_questionnaire = nil
protocol.invitation_text = 'Je bent uitgenodigd door je coach om een vragenlijst in te vullen.'
protocol.save!

bp_name = 'base-platform-subscription-psychological-competencies'
bp_push_subscription = protocol.push_subscriptions.find_by(name: bp_name)
bp_push_subscription ||= protocol.push_subscriptions.build(name: bp_name)
bp_push_subscription.method = 'POST'
bp_push_subscription.url = ENV['PUSH_SUBSCRIPTION_URL']
bp_push_subscription.save!

protocol.save!

name = 'psychological_competencies'
pc_questionnaire_id = Questionnaire.find_by(name: name)&.id
raise "Cannot find questionnaire: #{name}" unless pc_questionnaire_id

db_measurement = protocol.measurements.where(questionnaire_id: pc_questionnaire_id).first
db_measurement ||= protocol.measurements.build(questionnaire_id: pc_questionnaire_id)
db_measurement.period = nil
db_measurement.open_duration = 1.day
db_measurement.open_from_offset = 0
db_measurement.reward_points = 0
db_measurement.stop_measurement = true
db_measurement.should_invite = true
db_measurement.reminder_delay = 4.hours
db_measurement.redirect_url = ENV['BASE_PLATFORM_URL']
db_measurement.only_redirect_if_nothing_else_ready = true
db_measurement.save!
