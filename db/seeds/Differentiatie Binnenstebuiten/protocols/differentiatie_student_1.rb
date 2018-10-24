default_protocol_duration = (Date.new(2019,4,18) - Date.new(2018,10,29)).to_i
default_reward_points = 100

########################
## studenten Engels 1 ##
########################

pr_name = 'differentiatie_studenten_1'
db_name = 'Differentiatie Binnenstebuiten Scholieren Engels'
ic_name = 'informed consent scholieren'
invitation_text = 'Er staat een nieuw dagboek van Engels voor je klaar. Klik op de volgende link om deze in te vullen. Alvast bedankt!'

protocol = Protocol.find_by_name(pr_name)
protocol ||= Protocol.new(name: pr_name)
protocol.duration = default_protocol_duration.days
protocol.informed_consent_questionnaire = Questionnaire.find_by_name(ic_name)
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
dagboekvragenlijst_id = Questionnaire.find_by_name(db_name)&.id
raise "Cannot find questionnaire: #{db_name}" unless dagboekvragenlijst_id

offsets = []
reminder_delays = []
open_durations = []

offsets << 2.day + 10.hours + 30.minutes # Wednesdays at 10:30
reminder_delays << nil  # No reminder
open_durations <<  5.hours + 20.minutes # Wednesdays at 15:50 (10 minutes before next questionnaire)

offsets << 2.days + 16.hours + 00.minutes # Wednesdays at 16:00
reminder_delays << 1.hour # 
open_durations << 7.hours 

offsets << 4.days + 9.hours + 40.minutes # Fridays at 9:40
reminder_delays << 7.hours + 20.minutes # Fridays at 17:00
open_durations << 13.hours + 20.minutes 

offsets.each_with_index do |of_offset, idx|
  reminder_delay = reminder_delays[idx]
  open_duration = open_durations[idx]

  db_measurement = protocol.measurements.where(questionnaire_id: dagboekvragenlijst_id,
                                              open_from_offset: of_offset).first
  db_measurement ||= protocol.measurements.build(questionnaire_id: dagboekvragenlijst_id)
  db_measurement.open_from_offset = of_offset
  db_measurement.period = 1.week
  db_measurement.reminder_delay = reminder_delay
  db_measurement.open_duration = open_duration
  db_measurement.reward_points = default_reward_points
  db_measurement.stop_measurement = false
  db_measurement.should_invite = true
  db_measurement.save!
end

