# ECO is 8 weeks, so we do 10 to be sure.
default_protocol_duration = 10.weeks  # evt eerder dynamisch afbreken
default_open_duration = 10.weeks
default_posttest_open_duration = nil
default_reward_points = 100

###############
## kct ##
###############

pr_name = 'kct'
protocol = Protocol.find_by_name(pr_name)
protocol ||= Protocol.new(name: pr_name)
protocol.duration = default_protocol_duration
protocol.informed_consent_questionnaire = nil
protocol.save!

# Add dagboekmetingen
questionnaires = [
  'KCT Maandag'
]

questionnaires.each do |name|
  of_offset = 0.days # Thursday noon
  dagboekvragenlijst_id = Questionnaire.find_by_name(name)&.id
  raise "Cannot find questionnaire: #{name}" unless dagboekvragenlijst_id
  db_measurement = protocol.measurements.where(questionnaire_id: dagboekvragenlijst_id).first
  db_measurement ||= protocol.measurements.build(questionnaire_id: dagboekvragenlijst_id)
  # Goal is invisible after filling in, and ALWAYS visible after a week.
  db_measurement.period = 5.days
  db_measurement.open_duration = default_open_duration
  db_measurement.open_from_offset = 0
  db_measurement.reward_points = default_reward_points
  db_measurement.stop_measurement = false
  db_measurement.should_invite = true
  db_measurement.save!
end
