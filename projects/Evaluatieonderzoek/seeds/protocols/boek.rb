# frozen_string_literal: true

# Boek

pr_name = 'boek'
boek_protocol = Protocol.find_by(name: pr_name)
boek_protocol ||= Protocol.new(name: pr_name)
boek_protocol.duration = 1.day

boek_protocol.save!

boek_name = 'boek'
boek_id = Questionnaire.find_by(name: boek_name)&.id
raise "Cannot find questionnaire: #{boek_name}" unless boek_id

boek_measurement = boek_protocol.measurements.find_by(questionnaire_id: boek_id)
boek_measurement ||= boek_protocol.measurements.build(questionnaire_id: boek_id)
boek_measurement.open_from_offset = 0 # open right away
boek_measurement.period = nil # one-off and not repeated
boek_measurement.open_duration = nil # always open
boek_measurement.reward_points = 0
boek_measurement.stop_measurement = true # unsubscribe immediately
boek_measurement.should_invite = false # don't send invitations
boek_measurement.redirect_url = '/klaar' # after filling out questionnaire, go to person edit page.
boek_measurement.save!
