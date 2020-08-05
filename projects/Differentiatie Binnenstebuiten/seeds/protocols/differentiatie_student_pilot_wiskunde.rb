default_protocol_duration = 2
default_open_duration = 13.hours
default_posttest_open_duration = nil
default_reward_points = 100

########################
## studenten wiskunde ##
########################

pr_name = 'differentiatie_studenten_pilot_wiskunde'
db_name = 'Differentiatie Binnenstebuiten Scholieren Wiskunde'
ic_name = 'informed consent scholieren'
invitation_text = 'Er staat een nieuw dagboek voor je klaar. Klik op de volgende link om deze in te vullen. Alvast bedankt!'

protocol = Protocol.find_by(name: pr_name)
protocol ||= Protocol.new(name: pr_name)
protocol.duration = default_protocol_duration.days
protocol.informed_consent_questionnaire = Questionnaire.find_by(name: ic_name)
raise 'informed consent questionnaire not found' unless protocol.informed_consent_questionnaire
protocol.invitation_text = invitation_text
protocol.save!

# Add rewards
protocol.rewards.destroy_all
reward = protocol.rewards.create!(threshold: 1, reward_points: 1)
reward.save!
reward = protocol.rewards.create!(threshold: 3, reward_points: 2)
reward.save!

# Add dagboekmetingen
dagboekvragenlijst_id = Questionnaire.find_by(name: db_name)&.id
raise "Cannot find questionnaire: #{db_name}" unless dagboekvragenlijst_id

(1..default_protocol_duration).each do |number_of_days|
  of_offset = number_of_days.days + 12.hours # Tuesday, Wednesday, Thursday, Friday at noon
  db_measurement = protocol.measurements.where(questionnaire_id: dagboekvragenlijst_id,
                                              open_from_offset: of_offset).first
  db_measurement ||= protocol.measurements.build(questionnaire_id: dagboekvragenlijst_id)
  db_measurement.open_from_offset = of_offset
  db_measurement.period = 1.week
  db_measurement.reminder_delay = 5.hours 
  db_measurement.open_duration = default_open_duration
  db_measurement.reward_points = default_reward_points
  db_measurement.stop_measurement = false
  db_measurement.should_invite = true
  db_measurement.save!
end
