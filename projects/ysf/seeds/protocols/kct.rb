default_protocol_duration = 5.months + 2.weeks # Should at least cover until January, 1.
default_posttest_open_duration = nil
default_reward_points = 100

pr_name = 'kct'
protocol = Protocol.find_by(name: pr_name)
protocol ||= Protocol.new(name: pr_name)
protocol.duration = default_protocol_duration
protocol.informed_consent_questionnaire = nil
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
  dagboekvragenlijst_id = Questionnaire.find_by(name: name)&.id
  raise "Cannot find questionnaire: #{name}" unless dagboekvragenlijst_id
  db_measurement = protocol.measurements.where(questionnaire_id: dagboekvragenlijst_id).first
  db_measurement ||= protocol.measurements.build(questionnaire_id: dagboekvragenlijst_id)
  # One-off questionnaire; not repeated.
  db_measurement.period = nil
  db_measurement.open_duration = 2.months
  db_measurement.open_from_offset = 0.days
  db_measurement.reward_points = default_reward_points
  db_measurement.stop_measurement = false
  db_measurement.should_invite = true
  db_measurement.save!
end

questionnaires = [
  'KCT Start van de week',
  'KCT Eind van de week'
]

questionnaires.each do |name|
  dagboekvragenlijst_id = Questionnaire.find_by(name: name)&.id
  raise "Cannot find questionnaire: #{name}" unless dagboekvragenlijst_id
  db_measurement = protocol.measurements.where(questionnaire_id: dagboekvragenlijst_id).first
  db_measurement ||= protocol.measurements.build(questionnaire_id: dagboekvragenlijst_id)
  db_measurement.reward_points = default_reward_points
  db_measurement.stop_measurement = false
  db_measurement.should_invite = true
  db_measurement.period = nil # 1.week # Repeat weekly.

  # For an example, see `differentiatie_2.rb`.
  if name.include? "Start"
    # db_measurement.open_from_day = 'sunday'
    db_measurement.open_from_offset = 0.hours # 6.hours # Sunday at 06:00.
    db_measurement.open_duration = 2.months # 3.days # Close Wednesday at 06:00.
  else
    # db_measurement.open_from_day = 'friday'
    db_measurement.open_from_offset = 0.hours # 6.hours # Friday at 06:00.
    db_measurement.open_duration = 2.months # 2.days # Close Sunday at 6:00.
  end

  db_measurement.save!
end
