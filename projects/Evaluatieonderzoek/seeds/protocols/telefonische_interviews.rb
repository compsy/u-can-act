# Telefonische interviews

pr_name = 'telefonische_interviews'
ev_protocol = Protocol.find_by(name: pr_name)
ev_protocol ||= Protocol.new(name: pr_name)
ev_protocol.duration = 3.weeks # Give plenty of time to fill out the questionnaire
ev_protocol.save!

# Add questionnaire
ev_name = 'telefonische interviews'
ev_id = Questionnaire.find_by(name: ev_name)&.id
raise "Cannot find questionnaire: #{ev_name}" unless ev_id
ev_measurement = ev_protocol.measurements.find_by(questionnaire_id: ev_id)
ev_measurement ||= ev_protocol.measurements.build(questionnaire_id: ev_id)
ev_measurement.open_from_offset = 0 # open right away
ev_measurement.period = nil # one-off and not repeated
ev_measurement.open_duration = nil # always open
ev_measurement.reward_points = 0
ev_measurement.stop_measurement = true # unsubscribe immediately
ev_measurement.should_invite = false # don't send invitations
ev_measurement.save!
