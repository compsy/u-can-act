# frozen_string_literal: true

class Admin < ApplicationRecord
  has_secure_password
  validates :auth0_id_string, presence: true, uniqueness: true
  AUTH0_KEY_LOCATION = 'sub'

  def self.from_token_payload(payload)
    raise "Invalid payload #{payload}" unless payload.keys.include? AUTH0_KEY_LOCATION
    find_or_create_by(
      auth0_id_string: payload[AUTH0_KEY_LOCATION],
      password_digest: SecureRandom.hex(10)
    )
  end
end
