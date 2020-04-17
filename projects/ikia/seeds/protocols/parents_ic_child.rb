pr_name = File.basename(__FILE__)[0...-3]
boek_protocol = Protocol.find_by_name(pr_name)
boek_protocol ||= Protocol.new(name: pr_name)
boek_protocol.duration = 1.day

boek_protocol.save!

questionnaire_key = 'ouders_informed_consent_kind'
questionnaire = Questionnaire.find_by(key: questionnaire_key)
raise "ERROR: questionnaire not found: #{questionnaire_key}" unless questionnaire

questionnaire_id = questionnaire.id
boek_measurement = boek_protocol.measurements.find_by(questionnaire_id: questionnaire_id)
boek_measurement ||= boek_protocol.measurements.build(questionnaire_id: questionnaire_id)
boek_measurement.open_from_offset = 0 # open right away
boek_measurement.period = nil # one-off and not repeated
boek_measurement.open_duration = nil # open for the entire duration of the protocol
boek_measurement.reward_points = 0
boek_measurement.stop_measurement = true # unsubscribe immediately
boek_measurement.should_invite = false # don't send invitations
boek_measurement.redirect_url = ENV['IKIA_CALLBACK_CHILD_URL'] # is overridden by callback_url, unless ic was filled out
boek_measurement.save!
