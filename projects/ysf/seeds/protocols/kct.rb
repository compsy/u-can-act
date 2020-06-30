default_protocol_duration = 30.years  # evt eerder dynamisch afbreken
default_open_duration = 30.years
default_posttest_open_duration = nil
default_reward_points = 100

###############
## kct ##
###############

pr_name = 'kct'
protocol = Protocol.find_by(name: pr_name)
protocol ||= Protocol.new(name: pr_name)
protocol.duration = default_protocol_duration
protocol.informed_consent_questionnaire = nil
protocol.save!

# Add dagboekmetingen
questionnaires = [
  'KCT Alfa',
  'KCT Bravo',
  'KCT Charlie',
  'KCT Delta',
  'KCT Delta VCO',
  'KCT Delta Compagnie',
  'KCT Echo',
  'KCT Echo VCO',
  'KCT Echo Compagnie',
  'KCT Foxtrot',
  'KCT Golf',
  'KCT Hotel',
  'KCT Hotel VCO',
  'KCT Hotel Compagnie',
  'KCT India',
  'KCT Julliet',
  'KCT Kilo',
  'KCT Lima',
  'KCT Mike',
]

questionnaires.each do |name|
  of_offset = 0.days # Thursday noon
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
