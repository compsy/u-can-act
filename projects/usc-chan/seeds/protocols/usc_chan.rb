# frozen_string_literal: true

pr_name = 'usc_chan'
usc_protocol = Protocol.find_by(name: pr_name)
usc_protocol ||= Protocol.new(name: pr_name)

usc_protocol.informed_consent_questionnaire = Questionnaire.find_by(name: 'usc_chan_ic')
raise 'informed consent questionnaire not found' unless usc_protocol.informed_consent_questionnaire

usc_protocol.duration = 8.weeks
usc_protocol.invitation_text = 'Your next VitaMAPS questionnaire is ready to be filled out.'
usc_protocol.save!

# Add questionnaires
reminder_offset = 15.minutes
redirect_url = '/person/edit' # after filling out questionnaire, go to person edit page.

questionnaire_name = 'usc_chan'
questionnaire_id = Questionnaire.find_by(name: questionnaire_name)&.id
raise "Cannot find questionnaire: #{questionnaire_name}" unless questionnaire_id

[0, 6.hours, 12.hours].each do |offset|
  meas = usc_protocol.measurements.find_by(questionnaire_id: questionnaire_id, open_from_offset: offset)
  meas ||= usc_protocol.measurements.build(questionnaire_id: questionnaire_id, open_from_offset: offset)
  meas.period = 1.day
  meas.open_from_offset = offset
  meas.open_duration = 1.hour
  meas.reward_points = 0
  meas.priority = 1
  meas.should_invite = true
  meas.reminder_delay = reminder_offset
  meas.redirect_url = redirect_url
  meas.only_redirect_if_nothing_else_ready = true
  meas.save!
end
