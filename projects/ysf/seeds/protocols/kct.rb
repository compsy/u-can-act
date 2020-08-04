default_protocol_duration = 30.years  # evt eerder dynamisch afbreken
default_open_duration = 30.years
default_posttest_open_duration = nil
default_reward_points = 100

pr_name = 'kct'
protocol = Protocol.find_by(name: pr_name)
protocol ||= Protocol.new(name: pr_name)
protocol.duration = default_protocol_duration
protocol.informed_consent_questionnaire = 'KCT Alfa'
protocol.save!

questionnaires = [
  'KCT Alfa',
  'KCT Bravo',
  'KCT Charlie',
  'KCT Delta',
  'KCT Echo',
  'KCT Foxtrot',
  'KCT Golf',
  'KCT Hotel',
  'KCT India',
  'KCT Julliet',
  'KCT Kilo',
  'KCT Lima',
  'KCT Mike'
]

questionnaires.each do |name|
  of_offset = 0.days
  dagboekvragenlijst_id = Questionnaire.find_by(name: name)&.id
  raise "Cannot find questionnaire: #{name}" unless dagboekvragenlijst_id
  db_measurement = protocol.measurements.where(questionnaire_id: dagboekvragenlijst_id).first
  db_measurement ||= protocol.measurements.build(questionnaire_id: dagboekvragenlijst_id)
  db_measurement.period = nil
  db_measurement.open_duration = default_open_duration
  db_measurement.open_from_offset = 0
  db_measurement.reward_points = default_reward_points
  db_measurement.stop_measurement = false
  db_measurement.should_invite = true
  db_measurement.save!
end

questionnaires = [
  'KCT Begin van de week',
  'KCT Eind van de week'
]

# It is unkown when exactly the KCT wants to show `KCT Begin van de week` or `KCT Eind van de week`, so the
# questionnaires are set to be available again after one day and are hidden by the frontend.
questionnaires.each do |name|
  of_offset = 0.days
  dagboekvragenlijst_id = Questionnaire.find_by(name: name)&.id
  raise "Cannot find questionnaire: #{name}" unless dagboekvragenlijst_id
  db_measurement = protocol.measurements.where(questionnaire_id: dagboekvragenlijst_id).first
  db_measurement ||= protocol.measurements.build(questionnaire_id: dagboekvragenlijst_id)
  # Repeat after one day.
  db_measurement.period = 1.days
  db_measurement.open_duration = default_open_duration
  db_measurement.open_from_offset = 0
  db_measurement.reward_points = default_reward_points
  db_measurement.stop_measurement = false
  db_measurement.should_invite = true
  db_measurement.save!
end
