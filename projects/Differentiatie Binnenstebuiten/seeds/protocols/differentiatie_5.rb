################
## Wiskunde 5 ##
################

def create_protocol(pr_name, db_name, ic_name, invitation_text)
  default_protocol_duration = (Date.new(2019,3,1) - Date.new(2018,10,29)).to_i
  default_reward_points = 100

  protocol = Protocol.find_by(name: pr_name)
  protocol ||= Protocol.new(name: pr_name)
  protocol.duration = default_protocol_duration.days

  # Only create informed consent if present
  if ic_name.present?
    protocol.informed_consent_questionnaire = Questionnaire.find_by(name: ic_name)
    raise 'informed consent questionnaire not found' unless protocol.informed_consent_questionnaire
  end

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

  offsets = []
  reminder_delays = []
  open_durations = []

  offsets << 13.hours + 55.minutes # Mondays at 13:55
  reminder_delays << 3.hours + 5.minutes  # Mondays at 17:00
  open_durations <<  9.hours + 5.minutes

  offsets << 2.days + 11.hours + 50.minutes # Wednesdays at 11:50
  reminder_delays << 5.hours + 10.minutes # Wednesdays at 17:00
  open_durations <<  11.hours + 10.minutes

  offsets << 3.days + 9.hours + 5.minutes # Thursdays at 9:05
  reminder_delays << 7.hours + 55.minutes # Thursdays at 17:00
  open_durations <<  13.hours + 55.minutes

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
end

pr_name = 'differentiatie_studenten_5'
db_name = 'Differentiatie Binnenstebuiten Scholieren Wiskunde'
ic_name = 'informed consent scholieren'
invitation_text = 'Er staat een nieuw dagboek voor je klaar. Klik op de volgende link om deze in te vullen. Alvast bedankt!'
create_protocol(pr_name, db_name, ic_name, invitation_text)

pr_name = 'differentiatie_docenten_5'
db_name = 'Differentiatie Binnenstebuiten Docenten'
ic_name = nil
invitation_text = 'Er staat een nieuw dagboek voor je klaar. Klik op de volgende link om deze in te vullen. Alvast bedankt!'
create_protocol(pr_name, db_name, ic_name, invitation_text)
