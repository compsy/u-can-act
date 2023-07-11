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
