# frozen_string_literal: true

class AuthUser < ApplicationRecord
  has_secure_password
  validates :auth0_id_string, presence: true, uniqueness: true
  belongs_to :person
  AUTH0_KEY_LOCATION = 'sub'
  SITE_LOCATION = 'https://kct.evionix.org'

  def self.from_token_payload(payload)
    metadata = payload[SITE_LOCATION]
    id = payload[AUTH0_KEY_LOCATION]
    raise "Invalid payload #{payload}" unless payload.key?(AUTH0_KEY_LOCATION)

    # TODO: Actually use the correct person parameters here!
    auth_user = CreateAnonymousUser.run!(auth0_id_string: id, team_name: metadata['team'])
    if auth_user.person.protocol_subscriptions.blank?
      SubscribeToProtocol.run!(protocol_name: metadata['protocol'],
                               person: auth_user.person)
    end
    auth_user
  end
end
