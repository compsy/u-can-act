require_relative '../protocol_helper'
require_relative '../questionnaires/mmm_questionnaire'

MMM_PROTOCOL_NAME = 'move_mood_motivation'
MMM_NOTIFICATION_NAME = 'base-platform-subscription-move-mood-motivation'
MMM_DEFAULT_PROTOCOL_DURATION = 30.days

protocol = create_or_update_protocol(MMM_PROTOCOL_NAME, MMM_DEFAULT_PROTOCOL_DURATION)

# Necessary to send the filled in response to the SDV platform
add_push_subscription(protocol, MMM_NOTIFICATION_NAME)

q_name = MMM_QUESTIONNAIRE_NAME
mmm_questionnaire_id = Questionnaire.find_by(name: q_name)&.id
raise "Cannot find questionnaire: #{q_name}" unless mmm_questionnaire_id

db_measurement = protocol.measurements.where(questionnaire_id: mmm_questionnaire_id).first
db_measurement ||= protocol.measurements.build(questionnaire_id: mmm_questionnaire_id)
db_measurement.open_from_offset = 0 # open right away
db_measurement.period = nil # one-off and not repeated
db_measurement.open_duration = nil # always open until the end of the protocol
db_measurement.reward_points = 0
db_measurement.stop_measurement = true # unsubscribe immediately
db_measurement.should_invite = true # Send invitation
db_measurement.redirect_url = ENV['BASE_PLATFORM_URL']
db_measurement.only_redirect_if_nothing_else_ready = true
db_measurement.save!
