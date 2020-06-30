##################
## Nederlands 3 ##
##################

def create_protocol(pr_name, db_name, ic_name, invitation_text)
  default_protocol_duration = (Date.new(2019,4,17) - Date.new(2018,10,29)).to_i
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

  offsets << 12.hours + 30.minutes # Mondays at 12:30
  reminder_delays << 4.hours + 30.minutes # Mondays at 1700
  open_durations <<  10.hours + 30.minutes 

  offsets << 2.days + 9.hours + 40.minutes # Wednesdays at 9:40
  reminder_delays << 7.hours + 20.minutes # Wednesdays at 17:00
  open_durations <<  13.hours + 20.minutes

  offsets << 3.days + 15.hours + 10.minutes # Thursdays at 15:10
  reminder_delays << 1.hour+ 50.minutes # Thursdays at 17:00
  open_durations <<  7.hours + 50.minutes

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
  
  if protocol.measurements.length != offsets.length
    puts "!!!!!!!!!!!!!!!!!!!!!!!!!WARNING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    puts "!!!!!!!!!!!!!!!!!!!!!!!!!WARNING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    puts "Too many measurements defined for this protocol (#{protocol.id} #{protocol.name})"
    puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  end
end

pr_name = 'differentiatie_studenten_3'
db_name = 'Differentiatie Binnenstebuiten Scholieren Nederlands'
ic_name = 'informed consent scholieren'
invitation_text = 'Er staat een nieuw dagboek van Nederlands voor je klaar. Klik op de volgende link om deze in te vullen. Alvast bedankt!'
create_protocol(pr_name, db_name, ic_name, invitation_text)

pr_name = 'differentiatie_docenten_3'
db_name = 'Differentiatie Binnenstebuiten Docenten'
ic_name = nil
invitation_text = 'Er staat een nieuw dagboek voor je klaar. Klik op de volgende link om deze in te vullen. Alvast bedankt!'
create_protocol(pr_name, db_name, ic_name, invitation_text)
