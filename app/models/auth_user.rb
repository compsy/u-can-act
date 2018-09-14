# frozen_string_literal: true

class AuthUser < ApplicationRecord
  has_secure_password
  validates :auth0_id_string, presence: true, uniqueness: true
  belongs_to :person, dependent: :destroy
  AUTH0_KEY_LOCATION = 'sub'

  ADMIN_ROLE = 'admin'
  USER_ROLE = 'user'

  class << self
    ##
    # This function gets called automatically when authorizing a user. So note
    # that if we raise from here, the authorization process stops and it might
    # be hard to debug.
    def from_token_payload(payload)
      metadata = payload[ENV['SITE_LOCATION']] || {}
      id = payload[AUTH0_KEY_LOCATION]
      raise "Invalid payload #{payload} - no sub key" unless payload.key?(AUTH0_KEY_LOCATION)

      # TODO: Actually use the correct person parameters here!
      team = metadata['team']
      auth_user = CreateAnonymousUser.run!(auth0_id_string: id, team_name: team)
      subscribe_to_protocol_if_needed(auth_user.person, metadata)
      auth_user
    end

    private

    def subscribe_to_protocol_if_needed(person, metadata)
      return if metadata['protocol'].nil?

      # A person can only be subscribed to the same protocol once
      return if person.protocol_subscriptions.any? { |protsub| protsub.protocol.name == metadata['protocol'] }
      SubscribeToProtocol.run!(protocol_name: metadata['protocol'], person: person)
    end
  end
end
