require_relative '../protocol_helper'
require_relative '../questionnaires/climbing_accident'

CLIMBING_ACCIDENT_PROTOCOL_NAME = 'climbing_accident'
CLIMBING_ACCIDENT_NOTIFICATION_NAME = 'base-platform-subscription-climbing-accident'
CLIMBING_ACCIDENT_DEFAULT_PROTOCOL_DURATION = 1.year

protocol = create_or_update_protocol(CLIMBING_ACCIDENT_PROTOCOL_NAME, CLIMBING_ACCIDENT_DEFAULT_PROTOCOL_DURATION)

# Necessary to send the filled in response to the SDV platform
add_push_subscription(protocol, CLIMBING_ACCIDENT_NOTIFICATION_NAME)

q_name = CLIMBING_ACCIDENT_QUESTIONNAIRE_NAME
questionnaire_id = Questionnaire.find_by(name: q_name)&.id
raise "Cannot find questionnaire: #{q_name}" unless questionnaire_id

db_measurement = protocol.measurements.where(questionnaire_id: questionnaire_id).first
db_measurement ||= protocol.measurements.build(questionnaire_id: questionnaire_id)
db_measurement.open_from_offset = 0 # open right away
db_measurement.period = nil # one-off and not repeated
db_measurement.open_duration = 1.day # Expire after one day.
db_measurement.reward_points = 0
db_measurement.stop_measurement = false # Don't unsubscribe from protocol
db_measurement.should_invite = false # Send invitation
db_measurement.redirect_url = ENV['BASE_PLATFORM_URL']
db_measurement.only_redirect_if_nothing_else_ready = true
db_measurement.save!

# Create one time response
protocol = Protocol.find_by(name: CLIMBING_ACCIDENT_PROTOCOL_NAME)
token = CLIMBING_ACCIDENT_PROTOCOL_NAME
otr = OneTimeResponse.find_by(token: token)
otr ||= OneTimeResponse.create!(token: token, protocol: protocol)
otr.update!(restricted: true)
puts "Climbing accident: #{Rails.application.routes.url_helpers.one_time_response_url(q: token)}"
