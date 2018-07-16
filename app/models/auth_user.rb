# frozen_string_literal: true

class AuthUser < ApplicationRecord
  has_secure_password
  validates :auth0_id_string, presence: true, uniqueness: true
  belongs_to :person
  AUTH0_KEY_LOCATION = 'sub'

  def self.from_token_payload(payload)
    id = payload[AUTH0_KEY_LOCATION]
    raise "Invalid payload #{payload}" unless payload.key?(AUTH0_KEY_LOCATION)

    # TODO: Actually use the correct person parameters here! and make the used team name more generic.

    user = CreateAnonymousUser.run!(auth0_id_string: id, team_name: 'KCT')

    SubscribeToProtocol.run!(protocol_name: 'kct', person_id: user.person.id) if user.person.protocol_subscriptions.blank?
    user
  end
end
