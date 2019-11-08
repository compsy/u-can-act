# frozen_string_literal: true

class AuthUser < ApplicationRecord
  has_secure_password
  validates :auth0_id_string, presence: true, uniqueness: true
  belongs_to :person, dependent: :destroy, optional: true
  AUTH0_KEY_LOCATION = 'sub'

  ADMIN_ROLE = 'admin'
  USER_ROLE = 'user'

  class << self
    # This function gets called automatically when authorizing a user. So note
    # that if we raise from here, the authorization process stops and it might
    # be hard to debug.
    def from_token_payload(payload)
      id = id_from_payload(payload)
      role = role_from_payload(payload)
      team = team_from_payload(payload)

      auth_user = CreateAnonymousUser.run!(
        auth0_id_string: id,
        team_name: team,
        role: role
      )

      return auth_user if ENV['START_PROTOCOL_ON_SUBSCRIPTION'] == 'false'

      subscribe_to_protocol_if_needed(auth_user.person, payload)
      auth_user
    end

    private

    def metadata_from_payload(payload)
      payload[Rails.application.config.settings.metadata_field] || {}
    end

    # Get the team from the provided payload, or use the default if nothing is found
    def team_from_payload(payload)
      metadata_from_payload(payload)['team'] || Rails.application.config.settings.default_team_name
    end

    def role_from_payload(payload)
      return ADMIN_ROLE if metadata_from_payload(payload)['roles']&.include?(ADMIN_ROLE)

      USER_ROLE
    end

    def id_from_payload(payload)
      id = payload[AUTH0_KEY_LOCATION]
      return id if id.present?

      raise "Invalid payload #{payload} - no sub key" unless payload.key?(AUTH0_KEY_LOCATION)
    end

    def subscribe_to_protocol_if_needed(person, payload)
      metadata = metadata_from_payload(payload)
      return if metadata['protocol'].nil?

      # A person can only be subscribed to the same protocol once
      return if person.protocol_subscriptions.any? { |protsub| protsub.protocol.name == metadata['protocol'] }

      SubscribeToProtocol.run!(protocol_name: metadata['protocol'], person: person)
    end
  end
end
