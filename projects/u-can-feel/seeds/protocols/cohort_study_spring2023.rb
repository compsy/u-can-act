# frozen_string_literal: true

questionnaire_keys = %w[demografie_voorjaar2023 wellbeing_voorjaar2023 school_voorjaar2023 socialnetworks_voorjaar2023 other_factors_voorjaar2023]

pr_name = File.basename(__FILE__)[0...-3]
cohort_protocol = Protocol.find_by(name: pr_name)
cohort_protocol ||= Protocol.new(name: pr_name)
cohort_protocol.duration = 2.weeks 
cohort_protocol.invitation_text = 'Het u-can-feel onderzoek is bijna afgelopen! Help je nog 1 keer mee door een aantal vragenlijsten in te vullen? Klik daarvoor op de volgende link. Alvast bedankt!'

cohort_protocol.informed_consent_questionnaire_id = nil  # these participants have already consented in the spring

cohort_protocol.save!
unused_measurement_ids = cohort_protocol.measurements.pluck(:id).to_set
questionnaire_keys.each_with_index do |questionnaire_key, idx|
  questionnaire = Questionnaire.find_by(key: questionnaire_key)
  raise "questionnaire #{questionnaire_key} not found" unless questionnaire

  # Create the protocol for the questionnaire

  questionnaire_id = questionnaire.id
  measurement = cohort_protocol.measurements.find_by(questionnaire_id: questionnaire_id)
  measurement ||= cohort_protocol.measurements.build(questionnaire_id: questionnaire_id)
  measurement.open_from_offset = 0 # open immediately
  measurement.open_from_day = nil # don't wait for a specific day
  measurement.period = nil # one-off and not repeated
  measurement.open_duration = nil # open for the entire duration of the protocol
  measurement.reminder_delay = 168.hours # send a reminder after 1 week
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
