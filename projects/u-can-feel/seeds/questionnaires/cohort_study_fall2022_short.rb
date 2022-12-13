# frozen_string_literal: true

questionnaire_keys = %w[demografie_najaar2022 wellbeing_najaar2022 school_najaar2022 socialnetworks_najaar2022 other_factors_najaar2022]

pr_name = File.basename(__FILE__)[0...-3]
cohort_protocol = Protocol.find_by(name: pr_name)
cohort_protocol ||= Protocol.new(name: pr_name)
cohort_protocol.duration = 168.hours
cohort_protocol.invitation_text = 'Hallo! Je hebt nog geen vragenlijsten ingevuld. Doe je nog een keer mee aan het u-can-feel onderzoek? Daar help je ons erg mee. Alvast erg bedankt! Klik op de volgende link om een aantal vragenlijsten in te vullen.'

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
  measurement.reminder_delay = 72.hours # send a reminder after 3 days
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