# frozen_string_literal: true

# Symposium

pr_name = 'symposium'
symposium_protocol = Protocol.find_by(name: pr_name)
symposium_protocol ||= Protocol.new(name: pr_name)
symposium_protocol.duration = 1.day

symposium_protocol.save!

symp_name = 'symposium'
symp_id = Questionnaire.find_by(name: symp_name)&.id
raise "Cannot find questionnaire: #{symp_name}" unless symp_id

symp_measurement = symposium_protocol.measurements.find_by(questionnaire_id: symp_id)
symp_measurement ||= symposium_protocol.measurements.build(questionnaire_id: symp_id)
symp_measurement.open_from_offset = 0 # open right away
symp_measurement.period = nil # one-off and not repeated
symp_measurement.open_duration = nil # always open
symp_measurement.reward_points = 0
symp_measurement.stop_measurement = true # unsubscribe immediately
symp_measurement.should_invite = false # don't send invitations
symp_measurement.redirect_url = '/klaar' # after filling out questionnaire, go to person edit page.
symp_measurement.save!
