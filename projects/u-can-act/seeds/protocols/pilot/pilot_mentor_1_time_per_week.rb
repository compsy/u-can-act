# frozen_string_literal: true

default_protocol_duration = 4.weeks
default_open_duration = 1.day
default_posttest_open_duration = nil
default_posttest_reward_points = 100

################################
# pilot - mentoren 1x per week #
################################
pr_name = 'pilot - mentoren 1x per week'
mentor_protocol = Protocol.find_by(name: pr_name)
mentor_protocol ||= Protocol.new(name: pr_name)
mentor_protocol.duration = default_protocol_duration
mentor_protocol.informed_consent_questionnaire = Questionnaire.find_by(name: 'informed consent mentoren 1x per week')
mentor_protocol.save!

db_name = 'dagboek mentoren'
of_offset = 3.days + 12.hours # Thursday noon
dagboekvragenlijst_id = Questionnaire.find_by(name: db_name)&.id
raise "Cannot find questionnaire: #{db_name}" unless dagboekvragenlijst_id

db_measurement = mentor_protocol.measurements.where(questionnaire_id: dagboekvragenlijst_id,
                                                    open_from_offset: of_offset).first
db_measurement ||= mentor_protocol.measurements.build(questionnaire_id: dagboekvragenlijst_id)
db_measurement.open_from_offset = of_offset
db_measurement.period = 1.week
db_measurement.open_duration = default_open_duration
db_measurement.reward_points = 100
db_measurement.save!

pr_name = 'pilot - mentoren nameting'
mentor_protocol = Protocol.find_by(name: pr_name)
mentor_protocol ||= Protocol.new(name: pr_name)
mentor_protocol.duration = default_protocol_duration
mentor_protocol.save!

# Add nameting/enquete
nm_name = 'nameting mentoren 1x per week'
nameting_id = Questionnaire.find_by(name: nm_name)&.id
raise "Cannot find questionnaire: #{nm_name}" unless nameting_id

nm_measurement = mentor_protocol.measurements.find_by(questionnaire_id: nameting_id)
nm_measurement ||= mentor_protocol.measurements.build(questionnaire_id: nameting_id)
nm_measurement.open_from_offset = 2.weeks + 3.days + 13.hours # Thursday 1pm last week
nm_measurement.period = nil
nm_measurement.open_duration = default_posttest_open_duration
nm_measurement.reward_points = default_posttest_reward_points
nm_measurement.save!
