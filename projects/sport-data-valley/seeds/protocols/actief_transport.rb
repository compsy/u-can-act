default_protocol_duration = 30.days

pr_name = 'actief_transport'
protocol = Protocol.find_by(name: pr_name)
protocol ||= Protocol.new(name: pr_name)
protocol.duration = default_protocol_duration
protocol.informed_consent_questionnaire = nil
protocol.invitation_text = 'Je bent uitgenodigd om een vragenlijst over actief transport in te vullen.'
protocol.save!

bp_name = 'base-platform-subscription-after-actief-transport'
bp_push_subscription = protocol.push_subscriptions.find_by(name: bp_name)
bp_push_subscription ||= protocol.push_subscriptions.build(name: bp_name)
bp_push_subscription.method = 'POST'
bp_push_subscription.url = ENV['PUSH_SUBSCRIPTION_URL']
bp_push_subscription.save!

protocol.save!

name = 'actief_transport'
dagboekvragenlijst_id = Questionnaire.find_by(name: name)&.id
raise "Cannot find questionnaire: #{name}" unless dagboekvragenlijst_id

db_measurement = protocol.measurements.where(questionnaire_id: dagboekvragenlijst_id).first
db_measurement ||= protocol.measurements.build(questionnaire_id: dagboekvragenlijst_id)
db_measurement.period = nil
db_measurement.open_duration = nil
db_measurement.open_from_offset = 0
db_measurement.reward_points = 0
db_measurement.stop_measurement = true
db_measurement.should_invite = true
db_measurement.redirect_url = ENV['BASE_PLATFORM_URL']
db_measurement.only_redirect_if_nothing_else_ready = true
db_measurement.save!