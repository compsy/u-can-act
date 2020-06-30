############################
## Nederlands 11 - Docent ##
############################

def create_protocol(pr_name, db_name, ic_name, invitation_text, offsets, reminder_delays, open_durations)
  default_protocol_duration = (Date.new(2019,4,17) - Date.new(2018,10,29)).to_i
  default_reward_points = 100

  protocol = Protocol.find_by(name: pr_name)
  protocol ||= Protocol.new(name: pr_name)
  protocol.duration = default_protocol_duration.days

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
    puts "Too many measurements defined for this protocol (#{protocol.id} #{protocol.name})"
    puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  end
end

db_name = 'Differentiatie Binnenstebuiten Docenten'
ic_name = nil

offsets = []
reminder_delays = []
open_durations = []

offsets << 1.day + 14.hours # Tuesdays at 14:00
reminder_delays << 3.hours # Tuesdays at 17:00
open_durations << 9.hours

offsets << 2.days + 14.hours # Wednesdays at 14:00
reminder_delays << 3.hours  # Wednesdays at 17:00
open_durations << 9.hours

offsets << 4.days + 14.hours # Fridays at 14:00
reminder_delays << 3.hours  # Fridays at 17:00
open_durations << 9.hours

pr_name = 'differentiatie_docenten_11a'
invitation_text = 'Er staat een nieuw dagboek voor klas 2b voor je klaar. Klik op de volgende link om deze in te vullen. Alvast bedankt!'
create_protocol(pr_name, db_name, ic_name, invitation_text, offsets, reminder_delays, open_durations)

offsets = []
reminder_delays = []
open_durations = []

offsets << 1.day + 11.hours + 15.minutes # Tuesdays at 11:15
reminder_delays << nil # No reminder because of the other measurement
open_durations << 2.hours + 35.minutes # Tuesdays at 13:50, because of other measurement (prot 11a)

offsets << 2.days + 13.hours + 15.minutes # Wednesdays at 13:15
reminder_delays << nil # No reminder because of the other measurement.
open_durations << 35.minutes # Wednesdays at 13:50, because of other measurement

offsets << 4.days + 13.hours + 15.minutes # Fridays at 13:15
reminder_delays << nil # No reminder because of the other measurement.
open_durations << 35.minutes 

pr_name = 'differentiatie_docenten_11b'
invitation_text = 'Er staat een nieuw dagboek voor klas 2c voor je klaar. Klik op de volgende link om deze in te vullen. Alvast bedankt!'
create_protocol(pr_name, db_name, ic_name, invitation_text, offsets, reminder_delays, open_durations)

