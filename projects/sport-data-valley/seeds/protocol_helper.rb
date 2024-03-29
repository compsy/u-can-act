# frozen_string_literal: true

def create_or_update_protocol(protocol_name, default_duration)
  protocol = Protocol.find_by(name: protocol_name)
  protocol ||= Protocol.new(name: protocol_name)
  protocol.duration = default_duration
  protocol.informed_consent_questionnaire = nil
  protocol.invitation_text = 'Je bent uitgenodigd door je coach om een vragenlijst in te vullen.'
  protocol.save!
  protocol
end

def add_push_subscription(protocol, push_subscription_name)
  bp_push_subscription = protocol.push_subscriptions.find_by(name: push_subscription_name)
  bp_push_subscription ||= protocol.push_subscriptions.build(name: push_subscription_name)
  bp_push_subscription.method = 'POST'
  bp_push_subscription.url = ENV['PUSH_SUBSCRIPTION_URL']
  bp_push_subscription.save!

  protocol.save!
end
