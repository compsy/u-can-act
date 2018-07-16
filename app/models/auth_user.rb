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
    auth_user = CreateAnonymousUser.run!(auth0_id_string: id, team_name: 'KCT')
    if auth_user.person.protocol_subscriptions.blank?
      SubscribeToProtocol.run!(protocol_name: 'kct', person: auth_user.person)
    end
    Rails.logger.info auth_user
    auth_user
  end
end
