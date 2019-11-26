# frozen_string_literal: true

pr_name = 'general-solo-protocol'
general_solo_protocol = Protocol.find_by_name(pr_name)
general_solo_protocol ||= Protocol.new(name: pr_name)
general_solo_protocol.duration = 365.days

general_solo_protocol.save!

# Add questionnaires
questionnaires = [
  'ostrc',
  'rpe',
  'rtt',
  'training_satisfaction',
  'wellness'
]
questionnaires.each_with_index do |questionnaire_name, idx|
  questionnaire_id = Questionnaire.find_by_name(questionnaire_name)&.id
  raise "Cannot find questionnaire: #{questionnaire_name}" unless questionnaire_id

  demo_measurement = general_solo_protocol.measurements.find_by_questionnaire_id(questionnaire_id)
  demo_measurement ||= general_solo_protocol.measurements.build(questionnaire_id: questionnaire_id)
  demo_measurement.open_from_offset = 0 # open right away
  demo_measurement.period = nil # one-off and not repeated
  demo_measurement.open_duration = nil # always open
  demo_measurement.reward_points = 0
  demo_measurement.stop_measurement = false
  demo_measurement.should_invite = false # don't send invitations
  #demo_measurement.redirect_url = 'localhost:3000' # after filling out questionnaire, go to person edit page.
  demo_measurement.save!
end
