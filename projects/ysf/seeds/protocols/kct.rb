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
  'KCT Sociogram',
  'KCT Ontbijt'
]

###
# Set metadata for all questionnaires.
###
questionnaires.each do |name|
  dagboekvragenlijst_id = Questionnaire.find_by(name: name)&.id
  raise "Cannot find questionnaire: #{name}" unless dagboekvragenlijst_id
  db_measurement = protocol.measurements.where(questionnaire_id: dagboekvragenlijst_id).first
  db_measurement ||= protocol.measurements.build(questionnaire_id: dagboekvragenlijst_id)
  db_measurement.period = nil # Doesn't repeat. One off.
  db_measurement.open_duration = 1.years
  db_measurement.open_from_offset = 0.days
  db_measurement.reward_points = default_reward_points
  db_measurement.stop_measurement = false
  db_measurement.should_invite = true
  db_measurement.save!
end

###
# Override metadata for start-eind and sociogram questionnaires.
###
questionnaires = [
  'KCT Start van de week',
  'KCT Eind van de week',
  'KCT Start van de week CT-Sniper',
  'KCT Eind van de week CT-Sniper',
  'KCT Sociogram',
  'KCT Ontbijt'
]

questionnaires.each do |name|
  dagboekvragenlijst_id = Questionnaire.find_by(name: name)&.id
  raise "Cannot find questionnaire: #{name}" unless dagboekvragenlijst_id
  db_measurement = protocol.measurements.where(questionnaire_id: dagboekvragenlijst_id).first
  db_measurement ||= protocol.measurements.build(questionnaire_id: dagboekvragenlijst_id)
  db_measurement.reward_points = default_reward_points
  db_measurement.stop_measurement = false # Filling out this measurement does not stop the protocol subscription.
  db_measurement.should_invite = false # Send invitation (SMS).
  db_measurement.period = 1.week # Repeat weekly.

  # For an example, see `differentiatie_2.rb` or `protocols/teens_diary.rb`.
  if name.include? "Start"
    db_measurement.open_from_day = 'sunday'
    db_measurement.open_from_offset = 6.hours # Sunday at 06:00.
    db_measurement.open_duration = 3.days + 6.hours # Close Wednesday at 12:00.
  elsif name.include?("Eind") || name.include?("Ontbijt")
    db_measurement.open_from_day = 'wednesday'
    db_measurement.open_from_offset = 12.hours # Wednesday at 12:00.
    db_measurement.open_duration = 4.days - 6.hours # Close Sunday at 06:00.
  else # Sociogram.
    db_measurement.open_from_day = 'sunday'
    db_measurement.open_from_offset = 4.hours # Sunday at 04:00.
    db_measurement.open_duration = 7.days - 2.hours # Close Sunday at 02:00.
  end

  db_measurement.save!
end
