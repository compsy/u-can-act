default_protocol_duration = 1.day  # evt eerder dynamisch afbreken

pr_name = 'squash_otr'
protocol = Protocol.find_by(name: pr_name)
protocol ||= Protocol.new(name: pr_name)

protocol.duration = default_protocol_duration
protocol.informed_consent_questionnaire = nil
protocol.invitation_text = 'Je bent uitgenodigd door je coach om een vragenlijst in te vullen.'
protocol.save!

name = 'squash'
squash_questionnaire_id = Questionnaire.find_by(name: name)&.id
raise "Cannot find questionnaire: #{name}" unless squash_questionnaire_id

db_measurement = protocol.measurements.where(questionnaire_id: squash_questionnaire_id).first
db_measurement ||= protocol.measurements.build(questionnaire_id: squash_questionnaire_id)
db_measurement.open_from_offset = 0 # open right away
db_measurement.period = nil # one-off and not repeated
db_measurement.open_duration = nil # always open
db_measurement.reward_points = 0
db_measurement.stop_measurement = true # unsubscribe immediately
db_measurement.should_invite = false # don't send invitations
db_measurement.redirect_url = ENV['BASE_PLATFORM_URL']
db_measurement.only_redirect_if_nothing_else_ready = true
db_measurement.save!
