# frozen_string_literal: true

pr_name = 'usc_chan'
usc_protocol = Protocol.find_by(name: pr_name)
usc_protocol ||= Protocol.new(name: pr_name)
usc_protocol.duration = 1.day
usc_protocol.informed_consent_questionnaire = Questionnaire.find_by(name: 'usc_chan_ic')
raise 'informed consent questionnaire not found' unless usc_protocol.informed_consent_questionnaire

usc_protocol.save!

# Add solo
questionnaire_name = 'usc_chan'
questionnaire_id = Questionnaire.find_by(name: questionnaire_name)&.id
raise "Cannot find questionnaire: #{questionnaire_name}" unless questionnaire_id

usc_measurement = usc_protocol.measurements.find_by(questionnaire_id: questionnaire_id)
usc_measurement ||= usc_protocol.measurements.build(questionnaire_id: questionnaire_id)
usc_measurement.open_from_offset = 0 # open right away
usc_measurement.period = nil # one-off and not repeated
usc_measurement.open_duration = nil # always open
usc_measurement.reward_points = 0
usc_measurement.stop_measurement = true # unsubscribe immediately
usc_measurement.should_invite = false # don't send invitations
usc_measurement.redirect_url = '/person/edit' # after filling out questionnaire, go to person edit page.
usc_measurement.save!
