# frozen_string_literal: true

pr_name = 'usc_chan'
usc_protocol = Protocol.find_by(name: pr_name)
usc_protocol ||= Protocol.new(name: pr_name)

usc_protocol.informed_consent_questionnaire = Questionnaire.find_by(name: 'usc_chan_ic')
raise 'informed consent questionnaire not found' unless usc_protocol.informed_consent_questionnaire

usc_protocol.duration = 8.weeks
usc_protocol.invitation_text = 'Your next vitaMAPS questionnaire is ready to be filled out.'
usc_protocol.save!

# Add push subscription
push_subscription_name = 'usc-chan-push-subscription'
push_subscription = usc_protocol.push_subscriptions.find_by(name: push_subscription_name)
push_subscription ||= usc_protocol.push_subscriptions.build(name: push_subscription_name)
push_subscription.method = 'POST'
push_subscription.url = ENV.fetch('PUSH_SUBSCRIPTION_URL')
push_subscription.save!

# Add questionnaires
reminder_offset = 15.minutes
redirect_url = "#{ENV.fetch('BASE_PLATFORM_URL')}/?source=questionnaire"

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
  meas.stop_measurement = false
  meas.save!
end
