# frozen_string_literal: true

questionnaire_key = 'consent_otr'
token = 'inschrijven'

pr_name = File.basename(__FILE__)[0...-3]
protocol = Protocol.find_by(name: pr_name)
protocol ||= Protocol.new(name: pr_name)
protocol.duration = 1.day
protocol.informed_consent_questionnaire = nil
protocol.save!

questionnaire = Questionnaire.find_by(key: questionnaire_key)
raise "Error: questionnaire for protocol #{pr_name} not found: #{questionnaire_key}" unless questionnaire
questionnaire_id = questionnaire.id

db_measurement = protocol.measurements.find_by(questionnaire_id: questionnaire_id)
db_measurement ||= protocol.measurements.build(questionnaire_id: questionnaire_id)
db_measurement.period = nil
db_measurement.open_duration = nil
db_measurement.open_from_offset = 0
db_measurement.stop_measurement = true
db_measurement.should_invite = false
db_measurement.redirect_url = '/klaar'
db_measurement.save!

# Create one time response
protocol = Protocol.find_by(name: pr_name)
otr = OneTimeResponse.find_by(token: token)
otr ||= OneTimeResponse.new(token: token)
otr.protocol = protocol
otr.save!

puts "Consent OTR protocol: #{Rails.application.routes.url_helpers.one_time_response_url(q: token)}"
puts ''
