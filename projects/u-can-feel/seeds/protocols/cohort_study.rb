# frozen_string_literal: true

# medio september 2020 open gesteld worden (idealiter op een datum en tijdstip die per school kan verschillen)
questionnaire_keys = %w[demografie wellbeing school socialnetworks other_factors]

pr_name = File.basename(__FILE__)[0...-3]
cohort_protocol = Protocol.find_by(name: pr_name)
cohort_protocol ||= Protocol.new(name: pr_name)
cohort_protocol.duration = 14.days
cohort_protocol.invitation_text = 'Je bent uitgenodigd door je school om mee te doen aan het u-can-feel onderzoek. Klik op de volgende link om een aantal vragenlijsten in te vullen.'

ic_key = 'informed_consent'
cohort_protocol.informed_consent_questionnaire = Questionnaire.find_by(key: ic_key)
raise "informed consent questionnaire #{ic_key} not found" unless cohort_protocol.informed_consent_questionnaire

cohort_protocol.save!
unused_measurement_ids = cohort_protocol.measurements.pluck(:id).to_set
questionnaire_keys.each_with_index do |questionnaire_key, idx|
  questionnaire = Questionnaire.find_by(key: questionnaire_key)
  raise "questionnaire #{questionnaire_key} not found" unless questionnaire

  # Create the protocol for the questionnaire

  questionnaire_id = questionnaire.id
  measurement = cohort_protocol.measurements.find_by(questionnaire_id: questionnaire_id)
  measurement ||= cohort_protocol.measurements.build(questionnaire_id: questionnaire_id)
  measurement.open_from_offset = 12.hours # open noon the next day
  measurement.open_from_day = 'saturday' # the open_from_offset is added to saturday at midnight
  measurement.period = nil # one-off and not repeated
  measurement.open_duration = nil # open for the entire duration of the protocol
  measurement.reminder_delay = 1.week # send a reminder after one week
  measurement.priority = questionnaire_keys.count - idx # ensure that the questionnaires are shown in the specified order
  measurement.stop_measurement = (questionnaire_key == questionnaire_keys.last) # stop the protocol after filling out
  measurement.should_invite = true # send invitations                    # the last questionnaire
  measurement.save!

  unused_measurement_ids.delete(measurement.id)
end

if unused_measurement_ids.present?
  puts "ERROR: unused measurements present: "
  puts unused_measurement_ids.map do |unused_id|
    Measurement.find(unused_id)&.questionnaire&.key || unused_id.to_s
  end.pretty_inspect
  raise "Error: unused measurement ids present"
end
