# frozen_string_literal: true

questionnaire_keys = %w[01_demographics 02_huishouden 03_auto 04_fietsen 05_scooter 06_deelauto 07_ov]

pr_name = File.basename(__FILE__)[0...-3]
profiling_protocol = Protocol.find_by(name: pr_name)
profiling_protocol ||= Protocol.new(name: pr_name)
profiling_protocol.duration = 1.week
profiling_protocol.invitation_text = 'Welkom bij het UMO onderzoek. De eerste vragenlijst staat voor je klaar.'

ic_key = '00_informed_consent'
profiling_protocol.informed_consent_questionnaire = Questionnaire.find_by(key: ic_key)
raise "informed consent questionnaire #{ic_key} not found" unless profiling_protocol.informed_consent_questionnaire

profiling_protocol.save!
unused_measurement_ids = profiling_protocol.measurements.pluck(:id).to_set
questionnaire_keys.each_with_index do |questionnaire_key, idx|
  questionnaire = Questionnaire.find_by(key: questionnaire_key)
  raise "questionnaire #{questionnaire_key} not found" unless questionnaire

  # Create the measurement for the questionnaire

  questionnaire_id = questionnaire.id
  measurement = profiling_protocol.measurements.find_by(questionnaire_id: questionnaire_id)
  measurement ||= profiling_protocol.measurements.build(questionnaire_id: questionnaire_id)
  measurement.open_from_offset = 0 # open immediately
  measurement.open_from_day = nil # don't wait for a specific day
  measurement.period = nil # one-off and not repeated
  measurement.open_duration = nil # open for the entire duration of the protocol
  measurement.reminder_delay = 24.hours # send a reminder after 24 hours
  measurement.priority = questionnaire_keys.count - idx # ensure that the questionnaires are shown in the specified order
  measurement.stop_measurement = (questionnaire_key == questionnaire_keys.last) # stop the protocol after filling out
  measurement.should_invite = true # send invitations                    # the last questionnaire
  # Uncomment line below if we want to redirect back to UMO page after filling out all parts of the profiling questionnaire
  # measurement.redirect_url = ENV['BASE_PLATFORM_URL']
  measurement.only_redirect_if_nothing_else_ready = true
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
