# frozen_string_literal: true

class AuthenticationVerifier
  def self.valid?(response_id, current_user)
    provided_person_id = Response.find_by(id: response_id)&.protocol_subscription&.person_id
    return true if provided_person_id == current_user&.id

    false
  end
end
