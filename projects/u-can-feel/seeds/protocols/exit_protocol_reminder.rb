# frozen_string_literal: true

# Uitsturen in september 2022
questionnaire_keys = %w[exit_lijst_reminder]

pr_name = File.basename(__FILE__)[0...-3]
exit_protocol = Protocol.find_by(name: pr_name)
exit_protocol ||= Protocol.new(name: pr_name)
exit_protocol.duration = 1.week
exit_protocol.invitation_text = 'Bedankt dat je mee hebt gedaan aan ons onderzoek! Wil je je beloning krijgen? Maak dan voor 9 september een account aan in de betalingstool! Kijk bij het laatste nieuws op onze website (u-can-feel.nl) voor informatie over wat je moet doen. Of klik op de link!'

# geen informed consent
exit_protocol.informed_consent_questionnaire_id = nil

exit_protocol.save!
unused_measurement_ids = exit_protocol.measurements.pluck(:id).to_set
questionnaire_keys.each_with_index do |questionnaire_key, idx|
  questionnaire = Questionnaire.find_by(key: questionnaire_key)
  raise "questionnaire #{questionnaire_key} not found" unless questionnaire

  # Create the protocol for the questionnaire

  questionnaire_id = questionnaire.id
  measurement = exit_protocol.measurements.find_by(questionnaire_id: questionnaire_id)
  measurement ||= exit_protocol.measurements.build(questionnaire_id: questionnaire_id)
  measurement.open_from_offset = 0 # open immediately
  measurement.open_from_day = nil # don't wait for a specific day
  measurement.period = nil # one-off and not repeated
  measurement.open_duration = nil # open for the entire duration of the protocol
  measurement.reminder_delay = 24.hours # send a reminder after 24 hours
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