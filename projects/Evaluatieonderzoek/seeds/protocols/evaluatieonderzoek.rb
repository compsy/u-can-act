# frozen_string_literal: true

# Evaluatieonderzoek

pr_name = 'evaluatieonderzoek'
ev_protocol = Protocol.find_by(name: pr_name)
ev_protocol ||= Protocol.new(name: pr_name)
ev_protocol.duration = 1.day
ev_protocol.informed_consent_questionnaire = Questionnaire.find_by(name: 'evaluatieonderzoek informed consent')
raise 'informed consent questionnaire not found' unless ev_protocol.informed_consent_questionnaire

ev_protocol.save!

# Add evaluatie
ev_name = 'evaluatieonderzoek'
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
ev_measurement.redirect_url = '/person/edit' # after filling out questionnaire, go to person edit page.
ev_measurement.save!
