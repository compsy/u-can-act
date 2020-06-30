# frozen_string_literal: true

default_protocol_duration = 4.weeks
default_open_duration = 1.day
default_posttest_open_duration = nil
default_posttest_reward_points = 100

###################################
## pilot - studenten 2x per week ##
###################################

pr_name = 'pilot - studenten 2x per week'
protocol = Protocol.find_by(name: pr_name)
protocol ||= Protocol.new(name: pr_name)
protocol.duration = default_protocol_duration
protocol.informed_consent_questionnaire = Questionnaire.find_by(name: 'informed consent studenten 2x per week')
protocol.save!

# Add rewards
reward = protocol.rewards.find_by(threshold: 1)
reward ||= protocol.rewards.build(threshold: 1, reward_points: 1)
reward.save!
reward = protocol.rewards.find_by(threshold: 5)
reward ||= protocol.rewards.build(threshold: 5, reward_points: 5)
reward.save!

# Add dagboekmetingen
db_name = 'dagboek studenten 2x per week maandag'
of_offset = 12.hours # Monday noon
dagboekvragenlijst_id = Questionnaire.find_by(name: db_name)&.id
raise "Cannot find questionnaire: #{db_name}" unless dagboekvragenlijst_id

db_measurement = protocol.measurements.where(questionnaire_id: dagboekvragenlijst_id,
                                             open_from_offset: of_offset).first
db_measurement ||= protocol.measurements.build(questionnaire_id: dagboekvragenlijst_id)
db_measurement.open_from_offset = of_offset
db_measurement.period = 1.week
db_measurement.open_duration = default_open_duration
db_measurement.reward_points = 100
db_measurement.save!

db_name = 'dagboek studenten 2x per week donderdag'
of_offset = 3.days + 12.hours # Thursday noon
dagboekvragenlijst_id = Questionnaire.find_by(name: db_name)&.id
raise "Cannot find questionnaire: #{db_name}" unless dagboekvragenlijst_id

db_measurement = protocol.measurements.where(questionnaire_id: dagboekvragenlijst_id,
                                             open_from_offset: of_offset).first
db_measurement ||= protocol.measurements.build(questionnaire_id: dagboekvragenlijst_id)
db_measurement.open_from_offset = of_offset
db_measurement.period = 1.week
db_measurement.open_duration = default_open_duration
db_measurement.reward_points = 100
db_measurement.save!

# Add nameting/enquete
nm_name = 'nameting studenten 2x per week'
nameting_id = Questionnaire.find_by(name: nm_name)&.id
raise "Cannot find questionnaire: #{nm_name}" unless nameting_id

nm_measurement = protocol.measurements.find_by(questionnaire_id: nameting_id)
nm_measurement ||= protocol.measurements.build(questionnaire_id: nameting_id)
nm_measurement.open_from_offset = 2.weeks + 3.days + 13.hours # Thursday 1pm last week
nm_measurement.period = nil
nm_measurement.open_duration = default_posttest_open_duration
nm_measurement.reward_points = default_posttest_reward_points
nm_measurement.save!
