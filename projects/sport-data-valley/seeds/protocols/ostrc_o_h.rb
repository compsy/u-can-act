default_protocol_duration = 1.day  # evt eerder dynamisch afbreken

pr_name = 'ostrc_o_h'
protocol = Protocol.find_by(name: pr_name)
protocol ||= Protocol.new(name: pr_name)

protocol.duration = default_protocol_duration
protocol.informed_consent_questionnaire = nil
protocol.invitation_text = 'Je bent uitgenodigd door je coach om een vragenlijst in te vullen.'
protocol.save!

bp_name = 'base-platform-subscription-ostrc-o-h'
bp_push_subscription = protocol.push_subscriptions.find_by(name: bp_name)
bp_push_subscription ||= protocol.push_subscriptions.build(name: bp_name)
bp_push_subscription.method = 'POST'
bp_push_subscription.url = ENV['PUSH_SUBSCRIPTION_URL']
bp_push_subscription.save!

protocol.save!

name = 'ostrc_o'
ostrc_o_qid = Questionnaire.find_by(name: name)&.id
raise "Cannot find questionnaire: #{name}" unless ostrc_o_qid

db_measurement = protocol.measurements.where(questionnaire_id: ostrc_o_qid).first
db_measurement ||= protocol.measurements.build(questionnaire_id: ostrc_o_qid)
db_measurement.period = nil
db_measurement.open_duration = 1.day
db_measurement.open_from_offset = 0
db_measurement.reward_points = 0
db_measurement.stop_measurement = false
db_measurement.should_invite = true
db_measurement.priority = 4
db_measurement.reminder_delay = 4.hours
db_measurement.redirect_url = nil
db_measurement.save!

name = 'ostrc_h'
ostrc_h_qid = Questionnaire.find_by(name: name)&.id
raise "Cannot find questionnaire: #{name}" unless ostrc_h_qid

db_measurement = protocol.measurements.where(questionnaire_id: ostrc_h_qid).first
db_measurement ||= protocol.measurements.build(questionnaire_id: ostrc_h_qid)
db_measurement.period = nil
db_measurement.open_duration = 1.day
db_measurement.open_from_offset = 0
db_measurement.reward_points = 0
db_measurement.stop_measurement = true
db_measurement.should_invite = true
db_measurement.priority = 3
db_measurement.reminder_delay = 4.hours
db_measurement.redirect_url = ENV['BASE_PLATFORM_URL']
db_measurement.save!
