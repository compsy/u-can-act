# frozen_string_literal: true

default_protocol_duration = 35.weeks # evt eerder dynamisch afbreken
default_open_duration = 30.hours     # "tot de volgende dag 6 uur"
default_posttest_open_duration = nil
default_posttest_reward_points = 100

############
# mentoren #
############

pr_name = 'mentoren dagboek'
mentor_protocol = Protocol.find_by(name: pr_name)
mentor_protocol ||= Protocol.new(name: pr_name)
mentor_protocol.duration = default_protocol_duration
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
db_measurement.stop_measurement = false
db_measurement.should_invite = true
db_measurement.save!

pr_name = 'mentoren voormeting/nameting'
mentor_protocol = Protocol.find_by(name: pr_name)
mentor_protocol ||= Protocol.new(name: pr_name)
mentor_protocol.duration = default_protocol_duration
mentor_protocol.informed_consent_questionnaire = Questionnaire.find_by(name: 'informed consent mentoren december 2017')
raise 'informed consent questionnaire not found' unless mentor_protocol.informed_consent_questionnaire

mentor_protocol.save!

# Add voormeting/enquete
vm_name = 'voormeting mentoren'
voormeting_id = Questionnaire.find_by(name: vm_name)&.id
raise "Cannot find questionnaire: #{vm_name}" unless voormeting_id

vm_measurement = mentor_protocol.measurements.find_by(questionnaire_id: voormeting_id)
vm_measurement ||= mentor_protocol.measurements.build(questionnaire_id: voormeting_id)
vm_measurement.open_from_offset = 2.days + 17.hours + 45.minutes # Wednesday 17:45
vm_measurement.period = nil
vm_measurement.open_duration = nil # always open
vm_measurement.reward_points = default_posttest_reward_points
vm_measurement.stop_measurement = false
vm_measurement.should_invite = true
vm_measurement.save!

# Add nameting/enquete
nm_name = 'nameting mentoren'
nameting_id = Questionnaire.find_by(name: nm_name)&.id
raise "Cannot find questionnaire: #{nm_name}" unless nameting_id

nm_measurement = mentor_protocol.measurements.find_by(questionnaire_id: nameting_id)
nm_measurement ||= mentor_protocol.measurements.build(questionnaire_id: nameting_id)
nm_measurement.open_from_offset = nil
nm_measurement.offset_till_end = 2.days + 12.hours
nm_measurement.period = nil
nm_measurement.open_duration = default_posttest_open_duration
nm_measurement.reward_points = default_posttest_reward_points
nm_measurement.stop_measurement = true
nm_measurement.should_invite = true
nm_measurement.save!
