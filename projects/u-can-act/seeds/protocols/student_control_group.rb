# frozen_string_literal: true

default_protocol_duration = 35.weeks # evt eerder dynamisch afbreken
default_open_duration = 30.hours     # "tot de volgende dag 6 uur"
default_posttest_open_duration = nil
default_reward_points = 100

###############
## studenten ##
###############

pr_name = 'studenten_control'
protocol = Protocol.find_by(name: pr_name)
protocol ||= Protocol.new(name: pr_name)
protocol.duration = default_protocol_duration
protocol.informed_consent_questionnaire = Questionnaire.find_by(name: 'informed consent studenten controle januari 2018')
raise 'informed consent questionnaire not found' unless protocol.informed_consent_questionnaire

protocol.save!

# Add rewards
protocol.rewards.destroy_all
reward = protocol.rewards.create!(threshold: 1, reward_points: 2)
reward.save!
reward = protocol.rewards.create!(threshold: 3, reward_points: 3)
reward.save!

# Add voormeting
vm_name = 'voormeting studenten'
voormeting_id = Questionnaire.find_by(name: vm_name)&.id
raise "Cannot find questionnaire: #{vm_name}" unless voormeting_id

vm_measurement = protocol.measurements.find_by(questionnaire_id: voormeting_id)
vm_measurement ||= protocol.measurements.build(questionnaire_id: voormeting_id)
vm_measurement.open_from_offset = 2.days + 17.hours + 45.minutes # Wednesday 17:45
vm_measurement.period = nil
vm_measurement.open_duration = nil
vm_measurement.reward_points = 0
vm_measurement.stop_measurement = false
vm_measurement.should_invite = true
vm_measurement.save!

# Add dagboekmetingen
db_name = 'dagboek studenten controle'
of_offset = 3.days + 12.hours # Thursday noon
dagboekvragenlijst_id = Questionnaire.find_by(name: db_name)&.id
raise "Cannot find questionnaire: #{db_name}" unless dagboekvragenlijst_id

db_measurement = protocol.measurements.where(questionnaire_id: dagboekvragenlijst_id,
                                             open_from_offset: of_offset).first
db_measurement ||= protocol.measurements.build(questionnaire_id: dagboekvragenlijst_id)
db_measurement.open_from_offset = of_offset
db_measurement.period = 1.week
db_measurement.open_duration = default_open_duration
db_measurement.reward_points = default_reward_points
db_measurement.stop_measurement = false
db_measurement.should_invite = true
db_measurement.save!

# Add nameting/enquete
nm_name = 'nameting studenten controle'
nameting_id = Questionnaire.find_by(name: nm_name)&.id
raise "Cannot find questionnaire: #{nm_name}" unless nameting_id

nm_measurement = protocol.measurements.find_by(questionnaire_id: nameting_id)
nm_measurement ||= protocol.measurements.build(questionnaire_id: nameting_id)
nm_measurement.open_from_offset = nil
nm_measurement.offset_till_end = 2.days + 12.hours
nm_measurement.period = nil
nm_measurement.open_duration = default_posttest_open_duration
nm_measurement.reward_points =  0
nm_measurement.stop_measurement = true
nm_measurement.should_invite = true
nm_measurement.redirect_url = '/person/edit'
nm_measurement.save!
