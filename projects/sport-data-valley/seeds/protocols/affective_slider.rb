# frozen_string_literal: true

default_protocol_duration = 1.day

# One protocol per affective slider questionnaire (start and end), each named after its questionnaire.
{
  'affective_slider' => 'base-platform-subscription-affective-slider',
  'affective_slider_end' => 'base-platform-subscription-affective-slider-end'
}.each do |name, bp_name|
  protocol = Protocol.find_by(name: name)
  protocol ||= Protocol.new(name: name)

  protocol.duration = default_protocol_duration
  protocol.informed_consent_questionnaire = nil
  protocol.invitation_text = 'Je bent uitgenodigd door je coach om een vragenlijst in te vullen.'
  protocol.save!

  bp_push_subscription = protocol.push_subscriptions.find_by(name: bp_name)
  bp_push_subscription ||= protocol.push_subscriptions.build(name: bp_name)
  bp_push_subscription.method = 'POST'
  bp_push_subscription.url = ENV.fetch('PUSH_SUBSCRIPTION_URL', nil)
  bp_push_subscription.save!

  protocol.save!

  questionnaire_id = Questionnaire.find_by(name: name)&.id
  raise "Cannot find questionnaire: #{name}" unless questionnaire_id

  db_measurement = protocol.measurements.where(questionnaire_id: questionnaire_id).first
  db_measurement ||= protocol.measurements.build(questionnaire_id: questionnaire_id)
  db_measurement.period = nil
  db_measurement.open_duration = 1.day
  db_measurement.open_from_offset = 0
  db_measurement.reward_points = 0
  db_measurement.stop_measurement = true
  db_measurement.should_invite = true
  db_measurement.reminder_delay = 4.hours
  db_measurement.redirect_url = ENV.fetch('BASE_PLATFORM_URL', nil)
  db_measurement.only_redirect_if_nothing_else_ready = true
  db_measurement.save!
end
