# frozen_string_literal: true

puts 'Generating protocols - Started'
protocol = Protocol.find_by_name('Studentenpilot - 1 keer per week')
protocol ||= Protocol.new(name: 'Studentenpilot - 1 keer per week')
protocol.duration = 3.weeks
protocol.save!

mentor_protocol = Protocol.find_by_name('Mentorpilot - 1 keer per week')
mentor_protocol ||= Protocol.new(name: 'Mentorpilot - 1 keer per week')
mentor_protocol.duration = 3.weeks
mentor_protocol.save!

# Add voormeting
voormeting_id = Questionnaire.find_by_name('Voormeting Studenten')&.id
raise 'Cannot find voormeting studenten' unless voormeting_id

vm_measurement = protocol.measurements.find_by_questionnaire_id(voormeting_id)
vm_measurement ||= protocol.measurements.build(questionnaire_id: voormeting_id)
vm_measurement.period = nil
vm_measurement.open_from_offset = 13.hours # Monday 1pm in the first week
vm_measurement.open_duration = nil
vm_measurement.reward_points = 10
vm_measurement.save!

# Add dagboekmetingen
dagboekvragenlijst_id = Questionnaire.find_by_name('Dagboekvragenlijst Studenten')&.id
raise 'Cannot find dagboekvragenlijst studenten' unless dagboekvragenlijst_id

db_measurement = protocol.measurements.find_by_questionnaire_id(dagboekvragenlijst_id)
db_measurement ||= protocol.measurements.build(questionnaire_id: dagboekvragenlijst_id)
db_measurement.period = 1.week
db_measurement.open_from_offset = 2.days + 13.hours # Wednesday 1pm
db_measurement.open_duration = 2.hours
db_measurement.reward_points = 10
db_measurement.save!


dagboekvragenlijst_id = Questionnaire.find_by_name('Dagboekvragenlijst Mentoren')&.id
raise 'Cannot find dagboekvragenlijst mentoren' unless dagboekvragenlijst_id

db_measurement = mentor_protocol.measurements.find_by_questionnaire_id(dagboekvragenlijst_id)
db_measurement ||= mentor_protocol.measurements.build(questionnaire_id: dagboekvragenlijst_id)
db_measurement.period = 1.week
db_measurement.open_from_offset = 2.days + 13.hours # Wednesday 1pm
db_measurement.open_duration = 24.hours
db_measurement.reward_points = 1000
db_measurement.save!

puts 'Generating protocols - Finished'
