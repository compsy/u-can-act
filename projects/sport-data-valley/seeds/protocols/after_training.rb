default_protocol_duration = 30.years  # evt eerder dynamisch afbreken
default_open_duration = 30.years

pr_name = 'after_training'
protocol = Protocol.find_by_name(pr_name)
protocol ||= Protocol.new(name: pr_name)
protocol.duration = default_protocol_duration
protocol.informed_consent_questionnaire = nil
protocol.save!

name = 'training_log'
of_offset = 0.days
dagboekvragenlijst_id = Questionnaire.find_by_name(name)&.id
raise "Cannot find questionnaire: #{name}" unless dagboekvragenlijst_id
db_measurement = protocol.measurements.where(questionnaire_id: dagboekvragenlijst_id).first
db_measurement ||= protocol.measurements.build(questionnaire_id: dagboekvragenlijst_id)
db_measurement.period = nil
db_measurement.open_duration = default_open_duration
db_measurement.open_from_offset = 0
db_measurement.reward_points = 0
db_measurement.stop_measurement = false
db_measurement.should_invite = true
db_measurement.redirect_url = ENV['BASE_PLATFORM_URL']
db_measurement.save!
