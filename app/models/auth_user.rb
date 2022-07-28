# frozen_string_literal: true

class AuthUser < ApplicationRecord
  has_secure_password
  validates :auth0_id_string, presence: true, uniqueness: true
  belongs_to :person, dependent: :destroy, optional: true
  AUTH0_KEY_LOCATION = 'sub'

  ADMIN_ACCESS_LEVEL = 'admin'
  USER_ACCESS_LEVEL = 'user'

  # Used when creating a jwt token for a user
  def jwt_subject
    auth0_id_string
  end

  def generate_token
    request_env = {}
    Warden::JWTAuth::Hooks.new.send(:add_token_to_env,
                                    self,
                                    :user,
                                    request_env)
  end

  class << self
    # This function gets called automatically when authorizing a user. So note
    # that if we raise from here, the authorization process stops and it might
    # be hard to debug.
    def from_token_payload(payload)
      id = id_from_payload(payload)
      access_level = access_level_from_payload(payload)
      team = team_from_payload(payload)
      role = role_from_payload(payload)
      email = email_from_payload(payload)
      auth_user = nil

      RedisMutex.with_lock("CreateAnonymousUser:#{id}", block: 5) do
        auth_user = CreateAnonymousUser.run!(
          auth0_id_string: id,
          team_name: team,
          role_title: role,
          access_level: access_level,
          email: email
        )
      end

      # Note that we only subscribe the person if the protocol is provided in
      # the metadata.
      subscribe_to_protocol_if_needed(auth_user.person, payload) if auth_user&.person.present?
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
      metadata_from_payload(payload)['role']
    end

    def email_from_payload(payload)
      metadata_from_payload(payload)['email']
    end

    def protocol_from_payload(payload)
      metadata_from_payload(payload)['protocol']
    end

    def access_level_from_payload(payload)
      # Roles is also checked here for backwards compatibility
      role_admin = metadata_from_payload(payload)['roles']&.include?(ADMIN_ACCESS_LEVEL)
      access_level_admin = metadata_from_payload(payload)['access_level']&.include?(ADMIN_ACCESS_LEVEL)

      if role_admin
        ActiveSupport::Deprecation
          .warn('roles should not be used in the payload anymore. ' \
                'This was renamed to access_level. ' \
                'Please update the payload.')
      end

      return ADMIN_ACCESS_LEVEL if role_admin || access_level_admin

      USER_ACCESS_LEVEL
    end

    def id_from_payload(payload)
      id = payload[AUTH0_KEY_LOCATION]
      return id if id.present?

      raise "Invalid payload #{payload} - no sub key" unless payload.key?(AUTH0_KEY_LOCATION)
    end

    def subscribe_to_protocol_if_needed(person, payload)
      protocol = protocol_from_payload(payload)
      return if protocol.blank?

      RedisMutex.with_lock("SubscribeToProtocol:#{person.id}:#{protocol}") do
        # A person can only be subscribed to the same protocol once
        person.reload
        unless person.protocol_subscriptions.any? { |protsub| protsub.protocol.name == protocol }
          SubscribeToProtocol.run!(protocol_name: protocol, person: person)
        end
      end
    end
  end
end
