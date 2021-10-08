default_protocol_duration = 1.day  # evt eerder dynamisch afbreken

pr_name = 'training_log'
protocol = Protocol.find_by(name: pr_name)
protocol ||= Protocol.new(name: pr_name)
protocol.duration = default_protocol_duration
protocol.informed_consent_questionnaire = nil
protocol.invitation_text = 'Je bent uitgenodigd door je coach om een vragenlijst in te vullen.'
protocol.save!

bp_name = 'base-platform-subscription-after-training'
bp_push_subscription = protocol.push_subscriptions.find_by(name: bp_name)
bp_push_subscription ||= protocol.push_subscriptions.build(name: bp_name)
bp_push_subscription.method = 'POST'
bp_push_subscription.url = ENV['PUSH_SUBSCRIPTION_URL']
bp_push_subscription.save!

protocol.save!

name = 'training_log'
dagboekvragenlijst_id = Questionnaire.find_by(name: name)&.id
raise "Cannot find questionnaire: #{name}" unless dagboekvragenlijst_id

db_measurement = protocol.measurements.where(questionnaire_id: dagboekvragenlijst_id).first
db_measurement ||= protocol.measurements.build(questionnaire_id: dagboekvragenlijst_id)
db_measurement.period = nil
db_measurement.open_duration = nil
db_measurement.open_from_offset = 0
db_measurement.reward_points = 0
db_measurement.stop_measurement = true
db_measurement.should_invite = false
db_measurement.redirect_url = ENV['BASE_PLATFORM_URL']
db_measurement.only_redirect_if_nothing_else_ready = true
db_measurement.save!

# Create one time response
protocol = Protocol.find_by(name: pr_name)
token = pr_name
otr = OneTimeResponse.find_by(token: token)
otr ||= OneTimeResponse.create!(token: token, protocol: protocol)
puts "Training log: #{Rails.application.routes.url_helpers.one_time_response_url(q: token)}"
