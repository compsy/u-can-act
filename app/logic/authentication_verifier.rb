# frozen_string_literal: true

class AuthenticationVerifier
  def self.valid?(response_id)
    provided_response_id = Response.find_by_id(response_id)&.protocol_subscription&.person_id
    return false if provided_response_id != current_user&.id
  end
end
